/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the tracker processing logic using Vision.
*/

import AVFoundation
import UIKit
import Vision

enum VisionTrackerProcessorError: Error {
    case readerInitializationFailed
    case firstFrameReadFailed
    case objectTrackingFailed
    case rectangleDetectionFailed
}

protocol VisionTrackerProcessorDelegate: class {
    func displayFrame(_ frame: CVPixelBuffer?, withAffineTransform transform: CGAffineTransform, rects: [TrackedPolyRect]?)
    func displayFrameCounter(_ frame: Int)
    func didFinifshTracking()
}

class VisionTrackerProcessor {
    var videoAsset: AVAsset!
    var trackingLevel = VNRequestTrackingLevel.accurate
    var objectsToTrack = [TrackedPolyRect]()
    weak var delegate: VisionTrackerProcessorDelegate?

    private var cancelRequested = false
    private var initialRectObservations = [VNRectangleObservation]()

    init(videoAsset: AVAsset) {
        self.videoAsset = videoAsset
    }
    
    /// - Tag: SetInitialCondition
    func readAndDisplayFirstFrame(performRectanglesDetection: Bool) throws {
        guard let videoReader = VideoReader(videoAsset: videoAsset) else {
            throw VisionTrackerProcessorError.readerInitializationFailed
        }
        guard let firstFrame = videoReader.nextFrame() else {
            throw VisionTrackerProcessorError.firstFrameReadFailed
        }
        
        var firstFrameRects: [TrackedPolyRect]? = nil
        if performRectanglesDetection {
            // Vision Rectangle Detection
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: firstFrame, orientation: videoReader.orientation, options: [:])
            
            let rectangleDetectionRequest = VNDetectRectanglesRequest()
            rectangleDetectionRequest.minimumAspectRatio = VNAspectRatio(0.2)
            rectangleDetectionRequest.maximumAspectRatio = VNAspectRatio(1.0)
            rectangleDetectionRequest.minimumSize = Float(0.5)
            rectangleDetectionRequest.maximumObservations = Int(1)
            
            do {
                try imageRequestHandler.perform([rectangleDetectionRequest])
            } catch {
                throw VisionTrackerProcessorError.rectangleDetectionFailed
            }

            if let rectObservations = rectangleDetectionRequest.results as? [VNRectangleObservation] {
                initialRectObservations = rectObservations
                var detectedRects = [TrackedPolyRect]()
                for (rectangleObservation) in initialRectObservations {
                    detectedRects.append(TrackedPolyRect(observation: rectangleObservation))
                }
                firstFrameRects = detectedRects
            }
        }
        
        delegate?.displayFrame(firstFrame, withAffineTransform: videoReader.affineTransform, rects: firstFrameRects)
    }

    /// - Tag: PerformRequests
    func performTracking() throws {
        guard let videoReader = VideoReader(videoAsset: videoAsset) else {
            throw VisionTrackerProcessorError.readerInitializationFailed
        }

        guard videoReader.nextFrame() != nil else {
            throw VisionTrackerProcessorError.firstFrameReadFailed
        }
        
        cancelRequested = false
        
        // Create initial observations
        var inputObservations = [UUID: VNDetectedObjectObservation]()
        var trackedObjects = [UUID: TrackedPolyRect]()

        for rect in self.objectsToTrack {
            let inputObservation = VNDetectedObjectObservation(boundingBox: rect.boundingBox)
            inputObservations[inputObservation.uuid] = inputObservation
            trackedObjects[inputObservation.uuid] = rect
        }

        let requestHandler = VNSequenceRequestHandler()
        var frames = 1
        var trackingFailedForAtLeastOneObject = false
        
        while true {
            guard cancelRequested == false, let frame = videoReader.nextFrame() else {
                break
            }
    

            delegate?.displayFrameCounter(frames)
            frames += 1
            
            var rects = [TrackedPolyRect]()
            var trackingRequests = [VNRequest]()
            for inputObservation in inputObservations {
                let request: VNTrackingRequest!
                request = VNTrackObjectRequest(detectedObjectObservation: inputObservation.value)
                request.trackingLevel = trackingLevel

                trackingRequests.append(request)
            }
            
            // Perform array of requests
            do {
                try requestHandler.perform(trackingRequests, on: frame, orientation: videoReader.orientation)
            } catch {
                trackingFailedForAtLeastOneObject = true
            }

            for processedRequest in trackingRequests {
                guard let results = processedRequest.results as? [VNObservation] else {
                    continue
                }
                guard let observation = results.first as? VNDetectedObjectObservation else {
                    continue
                }
                
                rects.append(TrackedPolyRect(observation: observation))

                // Initialize inputObservation for the next iteration
                inputObservations[observation.uuid] = observation
            }

            // Draw results
            delegate?.displayFrame(frame, withAffineTransform: videoReader.affineTransform, rects: rects)

            usleep(useconds_t(videoReader.frameRateInSeconds))
        }

        delegate?.didFinifshTracking()
        
        if trackingFailedForAtLeastOneObject {
//            throw VisionTrackerProcessorError.objectTrackingFailed
        }
    }
        
    func cancelTracking() {
        cancelRequested = true
    }
}
