//
//  ReviewVC.swift
//  UMPY
//
//  Created by CBDev on 3/20/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import Player
import AVKit
import BottomPopup
import FirebaseStorage
import Toast_Swift
import SVProgressHUD
class ReviewVC: UIViewController {

    fileprivate var player = Player()
    enum State {
        case tracking
        case stopped
    }
    
    @IBOutlet weak var trackingView: TrackingImageView!
    var videoUrl: URL?
    
    var maxDuration = ""
    let storage = Storage.storage()
    @IBOutlet weak var curTimeLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    
    @IBOutlet weak var curProgress: UIProgressView!
    @IBOutlet weak var repeatImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var lbwImage: UIImageView!
    @IBOutlet weak var umpy2Image: UIImageView!
    
    var repeatOption = false
    
    @IBOutlet weak var topBarView: UIView!
    
    public var rectangleBorderColor = UIColor.clear
    public var rectangleFillColor = UIColor.clear
    public var circleBorderColor = UIColor.white
    public var circleBackgroundColor = UIColor.black
    public var selectedCircleBorderColor = UIColor.blue
    public var selectedCircleBackgroundColor = UIColor.blue
    
    public var rectangleBorderWidth:CGFloat = 2.0
    public var circleBorderWidth:CGFloat = 10.0
    
    public var circleBorderRadius:CGFloat = 5
    public var circleAlpha:CGFloat = 0.65
    public var rectangleAlpha:CGFloat = 1
    
    
    //wicket
    
    private let imgWKSmall = UIImageView()
    private let imgWKLarge = UIImageView()
    private let previewImage = UIImageView()
    private var isPreview = false
    var videoAsset: AVAsset! {
        didSet {
            visionProcessor = VisionTrackerProcessor(videoAsset: videoAsset)
            visionProcessor.delegate = self
            self.displayFirstVideoFrame()
        }
    }
    
    private var visionProcessor: VisionTrackerProcessor!
    private var workQueue = DispatchQueue(label: "com.apple.VisionTracker", qos: .userInitiated)
    private var objectsToTrack = [TrackedPolyRect]()
    private var state: State = .stopped {
        didSet {
            self.handleStateChange()
        }
    }
    
    private var gestureRecognizer:UIPanGestureRecognizer!
    
    //MARK:Local Variables
    var cropCircles = [UIView]()
    var selectedCircle : UIView? = nil
    var selectedIndex : Int?
    var m:Double = 0
    let leftBorder = CAShapeLayer()
    let rightBorder = CAShapeLayer()
    var oldPoint = CGPoint(x: 0, y: 0)
    var imagePicker = UIImagePickerController()
    
    var isShowOverlay = false {
        didSet {
            if isShowOverlay {
                self.view.layer.addSublayer(leftBorder)
                self.view.layer.addSublayer(rightBorder)
                self.view.addSubview(imgWKSmall)
                self.view.addSubview(imgWKLarge)
            }else{
                leftBorder.removeFromSuperlayer()
                rightBorder.removeFromSuperlayer()
                imgWKSmall.removeFromSuperview()
                imgWKLarge.removeFromSuperview()
            }
            
            for cropCircle in cropCircles {
                cropCircle.isHidden = !isShowOverlay
            }
        }
    }
    
    var isAutoDetect = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenBounds = UIScreen.main.bounds
        
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        topBarView.topCreateGradient()
        self.player.playerView.playerBackgroundColor = UIColor.black
        self.player.playerView.frame = CGRect(x: 0, y: 100, width: screenBounds.width, height: screenBounds.height * 0.7 - 100)
        self.player.view.frame = CGRect(x: 0, y: 100, width: screenBounds.width, height: screenBounds.height * 0.7 - 100)
//        self.addChild(self.player)
        
//        self.view.addSubview(player.view)
//        self.player.didMove(toParent: self)
        
        self.player.fillMode = PlayerFillMode.resizeAspect
        
        if(self.videoUrl != nil){
            self.player.url = self.videoUrl
        }else{
            self.player.url = URL(string: "https://www.youtube.com/watch?v=Z_t8aUcH_1w")
        }
        self.maxTimeLabel.text = self.maxDuration
        self.curTimeLabel.text = "00:00.000"
        self.lbwImage.clipsToBounds = true
//        self.curProgress.transform = curProgress.transform.scaledBy(x: 1, y: 5)
        self.lbwImage.layer.borderWidth = 1
        self.lbwImage.layer.borderColor = Constants.primaryColor.cgColor
        
        self.umpy2Image.layer.borderWidth = 1
        self.umpy2Image.layer.borderColor = Constants.primaryColor.cgColor
        
        imgWKLarge.contentMode = .scaleAspectFill
        imgWKLarge.image = UIImage(named: "cricket_wicket")
        imgWKLarge.isHidden = false

        imgWKSmall.contentMode = .scaleAspectFill
        imgWKSmall.image = UIImage(named: "cricket_wicket")
        imgWKSmall.isHidden  = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPreview(_:)))
        previewImage.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(imagePan(_:)))
        previewImage.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(imagePinched(_:)))
        previewImage.addGestureRecognizer(pinchGesture)
        previewImage.isUserInteractionEnabled = true
        previewImage.isMultipleTouchEnabled = true
        ///
        self.gestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(gesture:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadMatchVideo(_ sender: Any) {
        self.uploadVideoFile()
    }
    
    @IBAction func repeatVideo(_ sender: Any) {
        isAutoDetect = !isAutoDetect
        if(isAutoDetect){
            self.repeatImage.image = UIImage(named: "repeat_off")
            //            self.player.playbackLoops = false
            //            self.repeatOption = false
        }else{
            self.repeatImage.image = UIImage(named: "repeat_on")
            //            self.player.playbackLoops = true
            //            self.repeatOption = true
        }
        
    }
    
    @IBAction func backward(_ sender: Any) {
        
//        switch (self.player.playbackState.rawValue) {
//        case PlaybackState.stopped.rawValue:
//            break
//        case PlaybackState.paused.rawValue:
//            goBackWard()
//            break
//        case PlaybackState.playing.rawValue:
//            goBackWard()
//            break
//        case PlaybackState.failed.rawValue:
//            break
//        default:
//            break
//        }
        
        isShowOverlay = !isShowOverlay
    }
    
    @IBAction func onSelectVideo(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.movie"]
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func goBackWard(){
        var secs = NSInteger(self.player.currentTime)
        if(secs > 5){
            secs -= 5
        }
        else{
            secs = 0
        }
    
        self.player.seek(to: CMTime(seconds: Double(secs), preferredTimescale: CMTimeScale.max))
    }
    
    @IBAction func playAndPause(_ sender: Any) {
        
        handleStartStop()
    }
    
    @IBAction func showLbwWizard(_ sender: Any) {
        guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "LbwVC") as? LbwVC else { return }
 
        popupVC.popupDelegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func forward(_ sender: Any) {
        
//        switch (self.player.playbackState.rawValue) {
//        case PlaybackState.stopped.rawValue:
//            break
//        case PlaybackState.paused.rawValue:
//            goForward()
//            break
//        case PlaybackState.playing.rawValue:
//            goForward()
//            break
//        case PlaybackState.failed.rawValue:
//            break
//        default:
//            break
//        }
        self.view.removeGestureRecognizer(gestureRecognizer)
        setUpCropRegion()
    }
    
    func goForward(){
        var secs = NSInteger(self.player.currentTime)
        let maxSecs = NSInteger(self.player.maximumDuration)
        secs += 5
        if(secs > maxSecs){
            secs = maxSecs
        }
        
        self.player.seek(to: CMTime(seconds: Double(secs), preferredTimescale: CMTimeScale.max))
    }
    
    func uploadVideoFile() {
        SVProgressHUD.show(withStatus: "Uploading...")
        let fileName = "\(Date().timeIntervalSince1970).mp4"
        let ref = storage.reference(withPath: "/videos/" + fileName)
        ref.putFile(from: videoUrl!, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                print(downloadURL.absoluteString)
                SVProgressHUD.dismiss()
                self.addVideo(downloadURL: downloadURL.absoluteString)
  
            }
        }
        
    }
    
    func addVideo(downloadURL: String){
        let currentMatchID = UserDefaults.standard.string(forKey: "current_match_id")
  
        let permission = UserDefaults.standard.string(forKey: "video_permission")
        
        if(currentMatchID != nil && currentMatchID != ""){
            ApiManager.sharedInstance().uploadVideo(matchID: currentMatchID!, videoURL: downloadURL, permission: permission!, completion: {(simpleModel, strErr) in
                if let strErr = strErr {
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    
                    if let temp = simpleModel{
                        if(temp.status!){
                            self.view.makeToast("Successfully uploaded.")
                        }else{
                            self.view.makeToast("Upload Failed.")
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func fullScreenMode(_ sender: Any) {
        let videoURL = self.videoUrl
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
}

extension ReviewVC: PlayerPlaybackDelegate {
    
    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    public func playerPlaybackDidEnd(_ player: Player) {
        self.playImage.image = UIImage(named: "play_record")
    }
    
    public func playerCurrentTimeDidChange(_ player: Player) {
        

        self.curTimeLabel.text = player.currentTime.stringFromTimeInterval()
        let curVal = NSInteger(player.currentTime)
        let maxVal = NSInteger(player.maximumDuration)
        
        self.curProgress.setProgress(Float(curVal)/Float(maxVal), animated: true)
    }
    
    public func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
}

extension ReviewVC: PlayerDelegate{
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
}

extension ReviewVC: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}


extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
//        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d.%0.3d",minutes,seconds,ms)
        
    }
}

extension ReviewVC {
    
    private func displayFirstVideoFrame() {
        do {
            try visionProcessor.readAndDisplayFirstFrame(performRectanglesDetection: true)
            DispatchQueue.main.async {
                self.setUpCropRegion()
            }
        } catch {
            self.handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            var title: String
            var message: String
            if let processorError = error as? VisionTrackerProcessorError {
                title = "Vision Processor Error"
                switch processorError {
                case .firstFrameReadFailed:
                    message = "Cannot read the first frame from selected video."
                case .objectTrackingFailed:
                    message = "Tracking of one or more objects failed."
                case .readerInitializationFailed:
                    message = "Cannot create a Video Reader for selected video."
                case .rectangleDetectionFailed:
                    message = "Rectagle Detector failed to detect rectangles on the first frame of selected video."
                }
            } else {
                title = "Error"
                message = error.localizedDescription
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleStateChange() {
        var navBarHidden: Bool!
        switch state {
        case .stopped:
            self.playImage.image = UIImage(named: "play_record")
            
        case .tracking:
            self.playImage.image = UIImage(named: "pause_record")
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    private func handleStartStop() {
        
        switch state {
        case .tracking:
            // stop tracking
            
            previewImage.frame = self.view.bounds
            previewImage.contentMode = .scaleAspectFit
            previewImage.image = self.view.asImage(bounds: trackingView.frame)
            self.view.addSubview(previewImage)
            isPreview = true
            
            self.state = .stopped
            self.visionProcessor.cancelTracking()

            leftBorder.removeFromSuperlayer()
            rightBorder.removeFromSuperlayer()
            imgWKSmall.removeFromSuperview()
            imgWKLarge.removeFromSuperview()
            
            self.playImage.image = UIImage(named: "play_record")
            
        case .stopped:
            // initialize processor and start tracking
            objectsToTrack.removeAll()
            state = .tracking
            
            let tempPolyRect = getRectInTrackingView()
            trackingView.rubberbandingStart = tempPolyRect.origin
            trackingView.rubberbandingVector = CGPoint(x: tempPolyRect.size.width, y: tempPolyRect.size.height)
            
            let selectedBBox = trackingView.rubberbandingRectNormalized
            if selectedBBox.width > 0 && selectedBBox.height > 0 {
                objectsToTrack.append(TrackedPolyRect(cgRect: selectedBBox))
            }
            
            visionProcessor.objectsToTrack = objectsToTrack
            self.view.removeGestureRecognizer(self.gestureRecognizer)
            for cropCircle in cropCircles {
                cropCircle.removeFromSuperview()
            }
            
            workQueue.async {
                self.startTracking()
            }
            self.playImage.image = UIImage(named: "pause_record")
        }
    }
    
    private func startTracking() {
        do {
            try visionProcessor.performTracking()
        } catch {
            self.handleError(error)
        }
    }
    
    //MARK: Setup functions
    /**
     Sets up the crop region - the rectangle and the crop points, their appearance.
     */
    private func setUpCropRegion(){
        //Add border rectangle layer
        rightBorder.fillColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.3).cgColor
        rightBorder.lineWidth = rectangleBorderWidth
        rightBorder.strokeColor = UIColor.clear.cgColor
        
        leftBorder.fillColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.3).cgColor
        leftBorder.lineWidth = rectangleBorderWidth
        leftBorder.strokeColor = UIColor.clear.cgColor

        self.view.layer.addSublayer(rightBorder)
        self.view.layer.addSublayer(leftBorder)
        self.view.addSubview(imgWKSmall)
        self.view.addSubview(imgWKLarge)

        //Get crop rectangle
        var i = 1
        let x = trackingView.frame.origin.x
        let y = trackingView.frame.origin.y
        let width = trackingView.frame.width
        let height = trackingView.frame.height
        
        let points:[CGPoint]? = [
            CGPoint(x: width / 3, y: 50),
            CGPoint(x: width * 2 / 3, y: 50),
            CGPoint(x: width * 2 / 3 + 50, y: height - 50),
            CGPoint(x: width / 3 - 50, y: height - 50),
        ]
        var endPoints = [CGPoint]()
        /* Prints:
         (
         NSPoint: {0, 1},
         NSPoint: {374, 0},
         NSPoint: {374, 683},
         NSPoint: {0, 683}
         )
         */
        //Add crop points and circles
        if let points = points{
            var smallLength = height
            for i in (0...3) {
                let newPoint = points[i]
                endPoints.append(CGPoint(x: newPoint.x + x, y: newPoint.y+y))
                if i > 0 {
                    let prev = points[i - 1]
                    smallLength = smallLength > distance(prev, newPoint) ? distance(prev, newPoint) : smallLength
                }
            }
            if smallLength < (width / 3) {
                endPoints.removeAll()
                endPoints.append(CGPoint(x: x, y: y))
                endPoints.append(CGPoint(x: x+width, y: y))
                endPoints.append(CGPoint(x: x+width, y: y+height))
                endPoints.append(CGPoint(x: x, y: y+height))
            }
        }else{
            endPoints.append(CGPoint(x: x, y: y))
            endPoints.append(CGPoint(x: x+width, y: y))
            endPoints.append(CGPoint(x: x+width, y: y+height))
            endPoints.append(CGPoint(x: x, y: y+height))
        }
        
        for cropCircle in cropCircles {
            cropCircle.removeFromSuperview()
        }
        cropCircles.removeAll()
        while(i<=8){
            let cropCircle = UIView()
            cropCircle.alpha = circleAlpha
            //cropCircle.layer.cornerRadius = circleBorderRadius
            cropCircle.frame.size = CGSize(width: circleBorderRadius*2, height: circleBorderRadius*2)
            cropCircle.layer.borderWidth = circleBorderWidth
            cropCircle.layer.borderColor = circleBorderColor.cgColor
            cropCircle.backgroundColor = circleBackgroundColor
            /*
             1----2----3
             |         |
             8         4
             |         |
             7----6----5
             */
            switch i{
            case 1,3,5,7:
                cropCircle.center = endPoints[(i-1)/2]
            case 2,4,6,8:
                cropCircle.center = centerOf(firstPoint: endPoints[(i/2)-1], secondPoint: endPoints[i == 8 ? 0 : i/2])
            default:
                break
            }
            cropCircles.append(cropCircle)
            self.view.addSubview(cropCircle)
            i = i + 1
        }
        setUpGestureRecognizer()
        redrawBorderRectangle()
    }
    
    /**
     Draw/Redraw the crop rectangle such that it passes through the corner points
     */
    private func redrawBorderRectangle(){
        let beizierPath1 = UIBezierPath()
        beizierPath1.move(to: cropCircles[0].center)
//        beizierPath1.addLine(to: cropCircles[1].center)
        beizierPath1.addLine(to: CGPoint(x: cropCircles[1].center.x - 3, y: cropCircles[1].center.y))
        beizierPath1.addLine(to: CGPoint(x: cropCircles[5].center.x - 5, y: cropCircles[5].center.y))
        beizierPath1.addLine(to: cropCircles[6].center)
        beizierPath1.addLine(to: cropCircles[0].center)
        leftBorder.path = beizierPath1.cgPath
        
        let beizierPath2 = UIBezierPath()
//        beizierPath2.move(to: cropCircles[1].center)
        beizierPath2.move(to: CGPoint(x: cropCircles[1].center.x + 3, y: cropCircles[1].center.y))
        beizierPath2.addLine(to: cropCircles[2].center)
        beizierPath2.addLine(to: cropCircles[4].center)
        beizierPath2.addLine(to: CGPoint(x: cropCircles[5].center.x + 5, y: cropCircles[5].center.y))
        beizierPath2.addLine(to: CGPoint(x: cropCircles[1].center.x + 3, y: cropCircles[1].center.y))
        rightBorder.path = beizierPath2.cgPath
        
        imgWKLarge.frame = CGRect(x: cropCircles[5].center.x - 5, y: cropCircles[5].center.y - 30, width: 10, height: 30)
        imgWKSmall.frame = CGRect(x: cropCircles[1].center.x - 3, y: cropCircles[1].center.y - 18, width: 6, height: 18)
    }
    
    
    /**
     Sets up pan gesture reconginzers for all 8 crop points on the crop rectangle.
     When the 4 corner points or moved, the size and angles in the rectangle varry accordingly.
     When the 4 edge points are moved, the corresponding edge moves parallel to the gesture.
     */
    private func setUpGestureRecognizer(){
        self.view.addGestureRecognizer(self.gestureRecognizer)
    }
    
    @objc internal func panGesture(gesture : UIPanGestureRecognizer){
        let point = gesture.location(in: self.view)
        if(gesture.state == UIGestureRecognizer.State.began){
            selectedIndex = nil
            //Setup the point
            for i in stride(from: 1, to: 8, by: 2){
                let newFrame = CGRect(x: cropCircles[i].center.x, y: cropCircles[i].center.y, width: cropCircles[i].frame.width, height: cropCircles[i].frame.height)
                if(newFrame.contains(point)){
                    selectedIndex = i
                    let pt1 = cropCircles[selectedIndex! - 1].center
                    let pt2 = cropCircles[(selectedIndex! == 7 ? 0 : selectedIndex! + 1)].center
                    m = ((Double)(pt1.y - pt2.y)/(Double)(pt2.x - pt1.x))
                    cropCircles[selectedIndex!].backgroundColor = selectedCircleBackgroundColor
                    cropCircles[selectedIndex!].layer.borderColor = selectedCircleBorderColor.cgColor
                    
                    break
                }
            }
            if(selectedIndex == nil){
                selectedIndex = getClosestCorner(point: point)
                oldPoint = point
                cropCircles[selectedIndex!].backgroundColor = selectedCircleBackgroundColor
                cropCircles[selectedIndex!].layer.borderColor = selectedCircleBorderColor.cgColor
                
            }
        }
        if let selectedIndex = selectedIndex {
            if((selectedIndex) % 2 != 0){
                //Do complex stuff
                let pt1 = cropCircles[selectedIndex - 1]
                let pt2 = cropCircles[(selectedIndex == 7 ? 0 : selectedIndex + 1)]
                let pt1New = getNewPoint(pt1: pt1.center,pt2: pt2.center,point: point,m: m)
                let pt2New = getNewPoint(pt1: pt2.center, pt2: pt1.center, point: point,m: m)
                if(isInsideFrame(pt: pt1New) && isInsideFrame(pt: pt2New)){
                    pt1.center = pt1New
                    pt2.center = pt2New
                }
            }else{// Pan gesure for edge points - move the corresponding edge parallel to its old position and passing through the gesture point
                let edge = cropCircles[selectedIndex].center
                let newPoint = CGPoint(x: edge.x + (point.x - oldPoint.x) , y: edge.y + (point.y - oldPoint.y) )
                oldPoint = point
                let boundedX = min(max(newPoint.x, trackingView.frame.origin.x),(trackingView.frame.origin.x + trackingView.frame.size.width))
                let boundedY = min(max(newPoint.y, trackingView.frame.origin.y),(trackingView.frame.origin.y + trackingView.frame.size.height))
                let finalPoint = CGPoint(x: boundedX, y: boundedY)
                cropCircles[selectedIndex].center = finalPoint
            }
            moveNonCornerPoints()
            redrawBorderRectangle()
            
        }
        
        if(gesture.state == UIGestureRecognizer.State.ended){
            if let selectedIndex = selectedIndex{
                cropCircles[selectedIndex].backgroundColor = circleBackgroundColor
                cropCircles[selectedIndex].layer.borderColor = circleBorderColor.cgColor
            }
            selectedIndex = nil
            
            //Check if the quadrilateral is concave/convex/complex
            checkQuadrilateral()
            
        }
    }
    
    /**
     Updates the metaData of the image if its orientation is landscape
     */
    private func normalizedImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImage.Orientation.up) {
            return image;
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    
    //MARK: Post setup methods
    /**
     Reorder the points that form a complex quadrilateral to a convex one.
     */
    private func reorderEndPoints(){
        let endPoints = [cropCircles[0].center, cropCircles[2].center, cropCircles[4].center, cropCircles[6].center]
        var low = cropCircles[0].center
        var high = low;
        for point in endPoints{
            low.x = min(point.x, low.x);
            low.y = min(point.y, low.y);
            high.x = max(point.x, high.x);
            high.y = max(point.y, high.y);
        }
        
        let center = CGPoint(x: (low.x + high.x)/2,y: (low.y + high.y)/2)
        
        func angleFromPoint(point: CGPoint) -> Float{
            let theta = (Double)(atan2f((Float)(point.y - center.y), (Float)(point.x - center.x)))
            return fmodf((Float)(Double.pi - Double.pi/4 + theta), (Float)(2.0 * Double.pi))
        }
        
        var sortedArray = endPoints.sorted(by: {  (p1, p2)  in
            return angleFromPoint(point: p1) < angleFromPoint(point: p2)
        })
        
        for i in 0...3 {
            cropCircles[i*2].center = sortedArray[i]
        }
        moveNonCornerPoints()
        redrawBorderRectangle()
    }
    
    
    /**
     If the pan gesture doesnt happen on one of the crop circles, fetch the closest corner (only corners).
     */
    private func getClosestCorner(point: CGPoint) -> Int{
        var index = 0
        var minDistance = CGFloat.greatestFiniteMagnitude
        for i in stride(from: 0, to: 7, by: 2){
            let distance = distanceBetweenPoints(point1: point, point2: cropCircles[i].center)
            if(distance < minDistance){
                minDistance = distance
                index = i
            }
        }
        return index;
    }
    
    ///Assign edge points as the center of the corners
    private func moveNonCornerPoints(){
        for i in stride(from: 1, to: 8, by: 2){
            let prev = i-1
            let next = (i == 7 ? 0 : i+1)
            cropCircles[i].center = CGPoint(x: (cropCircles[prev].center.x + cropCircles[next].center.x)/2, y: (cropCircles[prev].center.y + cropCircles[next].center.y)/2)
        }
    }
    
    ///Before moving to a new location, check if the new point inside the cropView
    private func isInsideFrame(pt: CGPoint) -> Bool{
        if(pt.x < trackingView.frame.origin.x || pt.x > (trackingView.frame.origin.x + trackingView.frame.size.width)){
            return false
        }
        if(pt.y < trackingView.frame.origin.y || pt.y > (trackingView.frame.origin.y + trackingView.frame.size.height)){
            return false
        }
        return true
        
    }
    
    // MARK: Geometry Helpers
    ///Check if two points are on opposite sides of a line
    private func checkIfOppositeSides(p1:CGPoint, p2: CGPoint, l1: CGPoint, l2:CGPoint) -> Bool{
        let part1 = (l1.y-l2.y)*(p1.x-l1.x) + (l2.x-l1.x)*(p1.y-l1.y)
        let part2 = (l1.y-l2.y)*(p2.x-l1.x) + (l2.x-l1.x)*(p2.y-l1.y)
        if((part1*part2) < 0){
            return true
        }else{
            return false
        }
    }
    
    
    /// Get new corner points based on pan gestures
    private func getNewPoint(pt1: CGPoint, pt2:CGPoint, point: CGPoint, m:Double) -> CGPoint{
        if(abs(pt2.x - pt1.x) < 0.1){
            return CGPoint(x: pt1.x, y: point.y)
        }
        let c1:Double = (Double)(pt1.x) - (Double)(m*(Double)(pt1.y))
        let c2:Double =  (Double)(m*(Double)(point.x) + (Double)(point.y)) * (-1)
        let x = (-1*m*c2 + c1)/(m*m + 1)
        let y =  (-1*m*c1 - c2)/(m*m + 1)
        return CGPoint(x: x, y: y)
    }
    
    
    /// Checks if the points form a convex/concave/complex quadrilateral
    private func checkQuadrilateral(){
        let A = cropCircles[0].center
        let B = cropCircles[2].center
        let C = cropCircles[4].center
        let D = cropCircles[6].center
        
        if(checkIfOppositeSides(p1: B,p2: D,l1: A,l2: C) && checkIfOppositeSides(p1: A,p2: C,l1: B,l2: D)){//Convex
            leftBorder.strokeColor = rectangleBorderColor.cgColor
            rightBorder.strokeColor = rectangleBorderColor.cgColor
        }else if(!checkIfOppositeSides(p1: B,p2: D,l1: A,l2: C) && !checkIfOppositeSides(p1: A,p2: C,l1: B,l2: D)){//Complex
            leftBorder.strokeColor = rectangleBorderColor.cgColor
            rightBorder.strokeColor = rectangleBorderColor.cgColor
            reorderEndPoints()
        } else{//Concave
            leftBorder.strokeColor = UIColor.red.cgColor
            rightBorder.strokeColor = UIColor.red.cgColor
        }
    }
    
    ///Returns the distance between two CGPoints
    private func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat{
        let xPow = pow((point1.x - point2.x), 2)
        let yPow = pow((point1.y - point2.y), 2)
        return CGFloat(sqrtf(Float(xPow + yPow)))
        
    }
    
    ///Returns the center of two CGPoints
    private func centerOf(firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint{
        return CGPoint(x: (firstPoint.x+secondPoint.x)/2, y: (firstPoint.y + secondPoint.y)/2)
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    private func getRectInTrackingView() -> CGRect
    {
        let topLeftRect = CGRect(origin: getPointAtTrackingView(point: cropCircles[0].center), size: .zero)
        let topRightRect = CGRect(origin: getPointAtTrackingView(point: cropCircles[2].center), size: .zero)
        let bottomLeftRect = CGRect(origin: getPointAtTrackingView(point: cropCircles[6].center), size: .zero)
        let bottomRightRect = CGRect(origin: getPointAtTrackingView(point: cropCircles[4].center), size: .zero)
        return topLeftRect.union(topRightRect).union(bottomLeftRect).union(bottomRightRect)
    }
    
    private func getPointAtTrackingView(point:CGPoint) -> CGPoint {
        return CGPoint(x: point.x - trackingView.frame.origin.x, y: point.y - trackingView.frame.origin.y)
    }
    
    
    //Image preview.
    
    @objc private func imagePan(_ sender:UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc private func imagePinched(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    @objc private func dismissPreview(_ sender:UITapGestureRecognizer) {
        previewImage.image = nil
        previewImage.removeFromSuperview()
        isPreview = false
        self.displayFirstVideoFrame()
    }
}

extension ReviewVC : VisionTrackerProcessorDelegate {
    func displayFrame(_ frame: CVPixelBuffer?, withAffineTransform transform: CGAffineTransform, rects: [TrackedPolyRect]?) {
        DispatchQueue.main.async {
            if let frame = frame {
                let ciImage = CIImage(cvPixelBuffer: frame).transformed(by: transform)
                let uiImage = UIImage(ciImage: ciImage)
                self.trackingView.image = uiImage
            }
            

            if let trackedRects = rects, trackedRects.count > 0 {
                let tracked = trackedRects[0].boundingBox
                let origin = self.objectsToTrack[0].boundingBox
                let ctracked = self.trackingView.scale(cornerPoint: tracked.origin)
                let corigin = self.trackingView.scale(cornerPoint: origin.origin)
                let offsetX = ctracked.x - corigin.x
                let offsetY = ctracked.y - ctracked.y
                if self.isAutoDetect {
                    if !offsetX.isNaN && !offsetY.isNaN {
                        for cropCircle in self.cropCircles {
                            cropCircle.frame.origin.x -= offsetX
                            cropCircle.frame.origin.y -= offsetY
                        }
                        self.moveNonCornerPoints()
                        self.redrawBorderRectangle()
                    }
                }
                self.objectsToTrack[0] = trackedRects[0]
            }
            
//            self.trackingView.polyRects = rects ?? self.objectsToTrack
            self.trackingView.rubberbandingStart = CGPoint.zero
            self.trackingView.rubberbandingVector = CGPoint.zero
            
            self.trackingView.setNeedsDisplay()
        }
    }
    
    func displayFrameCounter(_ frame: Int) {
        
    }
    
    func didFinifshTracking() {
        
        if !isPreview {
            workQueue.async {
                self.leftBorder.removeFromSuperlayer()
                self.rightBorder.removeFromSuperlayer()
                self.imgWKSmall.removeFromSuperview()
                self.imgWKLarge.removeFromSuperview()
                self.displayFirstVideoFrame()
            }
        }

        DispatchQueue.main.async {
            self.state = .stopped
        }
    }
}

extension ReviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let url = info[.mediaURL] as? URL else {
            dismiss(animated: true, completion: nil)
            return
        }

        self.videoAsset = AVAsset(url: url)
        dismiss(animated: true, completion: nil)
    }
}
