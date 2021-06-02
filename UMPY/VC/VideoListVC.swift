//
//  VideoListVC.swift
//  UMPY
//
//  Created by CBDev on 4/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVKit
class VideoListVC: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var videoTableView: UITableView!
    
    var videoList: [VideoModel] = []
    var myVideoList:[VideoModel] = []
    var allVideoList:[VideoModel] = []
    var match_id = "0"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadVideoData()
        
    }
    func loadVideoData(){
        SVProgressHUD.show()
        ApiManager.sharedInstance().getVideos(matchID: match_id, completion: {(arrClass, strErr) in
            if let strErr = strErr{
                SVProgressHUD.showError(withStatus: strErr)
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass{
                    if list.status!{
                        self.videoList = list.list!
                        
                        self.videoTableView.reloadData()
                    }
                }
            }
        })
    }
    
    func loadAllPublicVideos(){
        SVProgressHUD.show()
        ApiManager.sharedInstance().getPublicVideos(matchID: "", completion: {(arrClass, strErr) in
            if let strErr = strErr{
                SVProgressHUD.showError(withStatus: strErr)
            }else{
                SVProgressHUD.dismiss()
                if let list = arrClass{
                    if list.status!{
                        self.videoList = list.list!
                        self.videoTableView.reloadData()
                    }
                }
            }
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topBarView.topCreateGradient()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.topBarView.frame
        rectShape.position = self.topBarView.center
        rectShape.path = UIBezierPath(roundedRect: self.topBarView.bounds, byRoundingCorners: [.bottomLeft ], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.topBarView.layer.mask = rectShape
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getVideoOption(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            loadVideoData()
        }else{
            loadAllPublicVideos()
        }
    }
}


extension VideoListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! VideoListCell
        cell.videoLabel.text = "\(indexPath.row + 1)"
        cell.containerView.layer.cornerRadius = 6
        
        // border
        cell.containerView.layer.borderWidth = 1.0
        cell.containerView.layer.borderColor = UIColor.white.cgColor
        
        // shadow
        cell.containerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.containerView.layer.shadowOpacity = 0.7
        cell.containerView.layer.shadowRadius = 4.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videoList[indexPath.row]
        let videoURL = URL(string: video.video_url!)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let video = self.videoList[indexPath.row]
            SVProgressHUD.show()
            ApiManager.sharedInstance().deleteVideo(videoID: video.id!, completion: {(simpleModel, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    SVProgressHUD.dismiss()
                    self.view.makeToast("Succesfully deleted.")
                    self.loadVideoData()
                    self.loadAllPublicVideos()
                }
            })
        }
    }
}
