//
//  CameraViewController.swift
//  UMPY
//
//  Created by CBDev on 3/15/19.
//  Copyright © 2019 CBDev. All rights reserved.
//
import UIKit
import AVFoundation
import Photos
import NextLevel

class CameraViewController: UIViewController {
    
    // MARK:varUIViewController
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var recordStatusText: UILabel!
    
    // MARK: - properties
    let NextLevelAlbumTitle = "Umpire"
//    internal var previewView: UIView?
    internal var gestureView: UIView?
    internal var focusView: FocusIndicatorView?
    internal var controlDockView: UIView?
    internal var metadataObjectViews: [UIView]?
    
    internal var recordButton: UIButton?
    internal var flipButton: UIButton?
    internal var flashButton: UIButton?
    internal var saveButton: UIButton?
    
    internal var reviewButton: UIButton?
    internal var pauseButton: UIButton?
    
    @IBOutlet weak var topBarView: UIView!
    var reviewMode = false
    var maxDuration = ""
    
    internal var longPressGestureRecognizer: UILongPressGestureRecognizer?
    internal var photoTapGestureRecognizer: UITapGestureRecognizer?
    internal var focusTapGestureRecognizer: UITapGestureRecognizer?
    internal var flipDoubleTapGestureRecognizer: UITapGestureRecognizer?
    
    internal var _panStartPoint: CGPoint = .zero
    internal var _panStartZoom: CGFloat = 0.0
    
    var recordStatus: Bool = false
    var pauseStatus: Bool = false
    @IBOutlet weak var previewView: UIView!
    
    var videoURL: URL?
    // MARK: - object lifecycle
    
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    deinit {
//    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        topBarView.topCreateGradient()
        
        self.view.backgroundColor = UIColor.black
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let screenBounds = UIScreen.main.bounds
        
        
        
        self.previewView.backgroundColor = UIColor.black
        NextLevel.shared.previewLayer.frame = self.previewView.bounds
        self.previewView.layer.addSublayer(NextLevel.shared.previewLayer)
        
        
        self.focusView = FocusIndicatorView(frame: .zero)
        
        // buttons
        
        self.recordButton = UIButton(type: .custom)
        if let recordButton = self.recordButton {
            recordButton.setImage(UIImage(named: "record_start"), for: .normal)
            recordButton.sizeToFit()
            recordButton.addTarget(self, action: #selector(handleRecordButton(_:)), for: .touchUpInside)
        }
        
        
//        self.flipButton = UIButton(type: .custom)
//        if let flipButton = self.flipButton {
//            flipButton.setImage(UIImage(named: "flip_button"), for: .normal)
//            flipButton.sizeToFit()
//            flipButton.addTarget(self, action: #selector(handleFlipButton(_:)), for: .touchUpInside)
//        }
        
        self.reviewButton = UIButton(type: .custom)
        if let reviewButton = self.reviewButton {
            reviewButton.setImage(UIImage(named: "drs_ic"), for: .normal)
            reviewButton.sizeToFit()
            reviewButton.addTarget(self, action: #selector(handleReviewButton(_:)), for: .touchUpInside)
        }
        
//        self.saveButton = UIButton(type: .custom)
//        if let saveButton = self.saveButton {
//            saveButton.setImage(UIImage(named: "save_button"), for: .normal)
//            saveButton.sizeToFit()
//            saveButton.addTarget(self, action: #selector(handleSaveButton(_:)), for: .touchUpInside)
//        }
        
        self.pauseButton = UIButton(type: .custom)
        if let pauseButton = self.pauseButton {
            pauseButton.setImage(UIImage(named: "pause_record"), for: .normal)
            pauseButton.sizeToFit()
            pauseButton.addTarget(self, action: #selector(handlePauseButton(_:)), for: .touchUpInside)
        }
        
        
        
        // capture control "dock"
        let controlDockHeight = screenBounds.height * 0.3
        self.controlDockView = UIView(frame: CGRect(x: 0, y: screenBounds.height - controlDockHeight, width: screenBounds.width, height: controlDockHeight))
        if let controlDockView = self.controlDockView {
            controlDockView.backgroundColor = UIColor.clear
            controlDockView.autoresizingMask = [.flexibleTopMargin]
            self.view.addSubview(controlDockView)
            
            if let recordButton = self.recordButton {
                recordButton.center = CGPoint(x: controlDockView.bounds.midX, y: controlDockView.bounds.midY)
                controlDockView.addSubview(recordButton)
            }
            
            if let reviewButton = self.reviewButton, let recordButton = self.recordButton {
                reviewButton.center = CGPoint(x: recordButton.center.x + controlDockView.bounds.width * 0.25 + reviewButton.bounds.width * 0.5, y: recordButton.center.y)
                controlDockView.addSubview(reviewButton)
            }
            
            if let pauseButton = self.pauseButton, let recordButton = self.recordButton {
                pauseButton.center = CGPoint(x: controlDockView.bounds.width * 0.25 - pauseButton.bounds.width * 0.5, y: recordButton.center.y)
                controlDockView.addSubview(pauseButton)
            }
        }
        
        // gestures
        self.gestureView = UIView(frame: CGRect(x: 0, y: 80, width: screenBounds.width, height: screenBounds.height-screenBounds.height*0.3))
        if let gestureView = self.gestureView, let controlDockView = self.controlDockView {
            gestureView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            gestureView.frame.size.height -= controlDockView.frame.height
            gestureView.backgroundColor = .clear
            self.view.addSubview(gestureView)
            
            self.focusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFocusTapGestureRecognizer(_:)))
            if let focusTapGestureRecognizer = self.focusTapGestureRecognizer {
                focusTapGestureRecognizer.delegate = self
                focusTapGestureRecognizer.numberOfTapsRequired = 1
                gestureView.addGestureRecognizer(focusTapGestureRecognizer)
            }
        }
        
        // Configure NextLevel by modifying the configuration ivars
        let nextLevel = NextLevel.shared
        nextLevel.delegate = self
        nextLevel.deviceDelegate = self
        nextLevel.flashDelegate = self
        nextLevel.videoDelegate = self
        nextLevel.photoDelegate = self
        nextLevel.metadataObjectsDelegate = self
        
        // video configuration
        let resolution = UserDefaults.standard.string(forKey: "video_resolution")!
        if(resolution == "0"){
            nextLevel.videoConfiguration.preset = AVCaptureSession.Preset.hd1280x720
        }else{
            nextLevel.videoConfiguration.preset = AVCaptureSession.Preset.cif352x288
        }
        nextLevel.videoConfiguration.preset = AVCaptureSession.Preset.hd1280x720
        nextLevel.videoConfiguration.bitRate = 5500000
        nextLevel.videoConfiguration.maxKeyFrameInterval = 30
        nextLevel.videoConfiguration.profileLevel = AVVideoProfileLevelH264HighAutoLevel
        
        // audio configuration
        let audio = UserDefaults.standard.string(forKey: "enable_audio")!
        if(audio == "0"){
            nextLevel.audioConfiguration.bitRate = 96000
        }
        else{
            nextLevel.audioConfiguration.bitRate = 0

        }
        // metadata objects configuration
        nextLevel.metadataObjectTypes = [AVMetadataObject.ObjectType.face, AVMetadataObject.ObjectType.qr]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try NextLevel.shared.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            NextLevel.requestAuthorization(forMediaType: AVMediaType.video, completionHandler: {(type, ParameterEvent) in
                
            })
            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio, completionHandler: {(type, ParameterEvent) in
                
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NextLevel.shared.stop()
    }
    

    
}

// MARK: - library
extension CameraViewController {
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
}

// MARK: - capture
extension CameraViewController {
    
    internal func startCapture() {
        self.photoTapGestureRecognizer?.isEnabled = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.recordButton?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (completed: Bool) in
        }
        NextLevel.shared.record()
    }
    
    internal func pauseCapture() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.recordButton?.transform = .identity
        }) { (completed: Bool) in
            NextLevel.shared.pause()
        }
    }
    
    internal func endCapture() {
        self.photoTapGestureRecognizer?.isEnabled = true
        
        if let session = NextLevel.shared.session {
            let totalSec = Int(session.totalDuration.seconds)
            var mins = "\(totalSec/60)"
            if mins.count < 2 {
                mins = "0" + mins
            }
            var secs = "\(totalSec%60)"
            if secs.count < 2{
                secs = "0" + secs
            }
            self.maxDuration = mins + ":" + secs
            
            if session.clips.count > 1 { 
                
                session.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
                    if let url = url {
                        self.videoURL = url
                        self.saveVideo(withURL: url)
                        
                        
                    } else if let _ = error {
                        print("failed to merge clips at the end of capture \(String(describing: error))")
                    }
                })
            } else if let lastClipUrl = session.lastClipUrl {
                self.videoURL = lastClipUrl
                self.saveVideo(withURL: lastClipUrl)
                
            } else if session.currentClipHasStarted {
                session.endClip(completionHandler: { (clip, error) in
                    if error == nil {
                        self.videoURL = clip?.url
                        self.saveVideo(withURL: (clip?.url)!)
                        
                    } else {
                        print("Error saving video: \(error?.localizedDescription ?? "")")
                    }
                })
            } else {
                // prompt that the video has been saved
                let alertController = UIAlertController(title: "Video Capture", message: "Not enough video captured!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    internal func authorizePhotoLibaryIfNecessary() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .restricted:
            fallthrough
        case .denied:
            let alertController = UIAlertController(title: "Oh no!", message: "Access denied.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    
                } else {
                    
                }
            })
            break
        case .authorized:
            
            break
        }
    }
    
    internal func saveVideo(withURL url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: self.NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: self.NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            
                            if(self.reviewMode == true){
                                if(self.videoURL != nil){
                                    let alertController = UIAlertController(title: "UMPY", message: "Do you want to go review mode?", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(UIAlertAction) in
                                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
                                        newViewController.videoUrl = self.videoURL
                                        newViewController.maxDuration = self.maxDuration
                                        self.present(newViewController, animated: true, completion: nil)
                                    }))
                                    alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                              
                                }
                            }else{
                                // prompt that the video has been saved
                                let alertController = UIAlertController(title: "Video Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                            }
                    

                        } else {
                            // prompt that the video has been saved
                            let alertController = UIAlertController(title: "Oops!", message: "Something failed!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
        })
    }
}

// MARK: - UIButton
extension CameraViewController {
    
    @objc internal func handleFlipButton(_ button: UIButton) {
        NextLevel.shared.flipCaptureDevicePosition()
    }
    
    internal func handleFlashModeButton(_ button: UIButton) {
    }
    
    @objc internal func handleSaveButton(_ button: UIButton) {
        self.endCapture()
    }
    
    @objc internal func handleRecordButton(_ button: UIButton){
        if(recordStatus){
            
            self.endCapture()
            self.recordStatus = false
            self.recordStatusText.text = "Stopped."
            self.recordButton?.setImage(UIImage(named: "record_start"), for: .normal)
            self.recordButton?.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        }else{
            self.startCapture()
            self.recordStatusText.text = "Recording..."
            self.recordStatus = true
            self.recordButton?.setImage(UIImage(named: "record_stop"), for: .normal)

        }
        
        self.recordButton?.sizeToFit()
        
    }
    
    @objc internal func handleReviewButton(_ button: UIButton){
        
        reviewMode = true
        self.endCapture()

    }
    
    @objc internal func handlePauseButton(_ button: UIButton){
        if(recordStatus){
            if(pauseStatus){
                self.startCapture()
                self.pauseStatus = false
                self.pauseButton?.setImage(UIImage(named: "pause_record"), for: .normal)
                self.recordStatusText.text = "Recording..."
            }else{
                self.pauseCapture()
                self.pauseStatus = true
                self.pauseButton?.setImage(UIImage(named: "play_record"), for: .normal)
                self.recordStatusText.text = "Paused..."
            }
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CameraViewController: UIGestureRecognizerDelegate {
    
    @objc internal func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:

            self._panStartPoint = gestureRecognizer.location(in: self.view)
            self._panStartZoom = CGFloat(NextLevel.shared.videoZoomFactor)
            break
        case .changed:
            let newPoint = gestureRecognizer.location(in: self.view)
            let scale = (self._panStartPoint.y / newPoint.y)
            let newZoom = (scale * self._panStartZoom)
            NextLevel.shared.videoZoomFactor = Float(newZoom)
            
            break
        case .ended:
            
            fallthrough
        case .cancelled:
            
            fallthrough
        case .failed:
            
            fallthrough
        default:
            break
        }
    }
}

extension CameraViewController {
    
    internal func handlePhotoTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // play system camera shutter sound
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        NextLevel.shared.capturePhotoFromVideo()
    }
    
    @objc internal func handleFocusTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: self.previewView)
        
        if let focusView = self.focusView {
            var focusFrame = focusView.frame
            focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
            focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
            focusView.frame = focusFrame
            
            self.previewView?.addSubview(focusView)
            focusView.startAnimation()
        }
        
        let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointConverted(fromLayerPoint: tapPoint)
        NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
    }
    
}

// MARK: - NextLevelDelegate
extension CameraViewController: NextLevelDelegate {
    
    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: AVMediaType) {
        print("NextLevel, authorization updated for media \(mediaType) status \(status)")
        if NextLevel.authorizationStatus(forMediaType: AVMediaType.video) == .authorized &&
            NextLevel.authorizationStatus(forMediaType: AVMediaType.audio) == .authorized {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else if status == .notAuthorized {
            // gracefully handle when audio/video is not authorized
            print("NextLevel doesn't have authorization for audio or video")
        }
    }
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
    }
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionWillStart")
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStart")
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStop")
    }
    
    // interruption
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
    }
    
    // mode
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelPreviewDelegate {
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopPreview(_ nextLevel: NextLevel) {
    }
    
}

extension CameraViewController: NextLevelDeviceDelegate {
    
    // position, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
    }
    
    // format
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format) {
    }
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
    }
    
    // lens
    func nextLevel(_ nextLevel: NextLevel, didChangeLensPosition lensPosition: Float) {
    }
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopFocus(_  nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelFlashDelegate
extension CameraViewController: NextLevelFlashAndTorchDelegate {
    
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelVideoDelegate
extension CameraViewController: NextLevelVideoDelegate {
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
        
    }
    
    
    // video zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
    }
    
    // video frame processing
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, onQueue queue: DispatchQueue) {
    }
    
    // enabled by isCustomContextVideoRenderingEnabled
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
    }
    
    // video recording session
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        // called when a configuration time limit is specified
        self.endCapture()
    }
    
    // video frame photo
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: self.NextLevelAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.NextLevelAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: self.NextLevelAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
            
        }
        
    }
    
}

// MARK: - NextLevelPhotoDelegate
extension CameraViewController: NextLevelPhotoDelegate {
    
    // photo
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: self.NextLevelAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.NextLevelAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: self.NextLevelAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
    }
    
    @available(iOS 11.0, *)
    func nextLevel(_ nextLevel: NextLevel, didFinishProcessingPhoto photo: AVCapturePhoto) {
    }
    
}

// MARK: - KVO
private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension CameraViewController {
    
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}

extension CameraViewController: NextLevelMetadataOutputObjectsDelegate {
    
    func metadataOutputObjects(_ nextLevel: NextLevel, didOutput metadataObjects: [AVMetadataObject]) {
        guard let previewView = self.previewView else {
            return
        }
        
        if let metadataObjectViews = metadataObjectViews {
            for view in metadataObjectViews {
                view.removeFromSuperview()
            }
            self.metadataObjectViews = nil
        }
        
        self.metadataObjectViews = metadataObjects.map { metadataObject in
            let view = UIView(frame: metadataObject.bounds)
            view.backgroundColor = UIColor.clear
            view.layer.borderColor = UIColor.yellow.cgColor
            view.layer.borderWidth = 1
            return view
        }
        
        if let metadataObjectViews = self.metadataObjectViews {
            for view in metadataObjectViews {
                previewView.addSubview(view)
            }
        }
    }
}
