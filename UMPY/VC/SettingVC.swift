//
//  SettingVC.swift
//  UMPY
//
//  Created by CBDev on 3/14/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
class SettingVC: UIViewController {
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var curDurationLabel: UILabel!
    
    @IBOutlet weak var timeDuration: UISlider!
    @IBOutlet weak var resolutionSeg: UISegmentedControl!
    
    @IBOutlet weak var permissionSeg: UISegmentedControl!
    @IBOutlet weak var enableAudioSeg: UISegmentedControl!
    var temp_sec = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettingInfo()
        
    }
    
    func loadSettingInfo(){
        let resolution = UserDefaults.standard.string(forKey: "video_resolution")!
        resolutionSeg.selectedSegmentIndex = Int(resolution)!
        let enableAudio = UserDefaults.standard.string(forKey: "enable_audio")
        enableAudioSeg.selectedSegmentIndex = Int(enableAudio!)!
        let privacy = UserDefaults.standard.string(forKey: "video_permission")
        permissionSeg.selectedSegmentIndex = Int(privacy!)!
        
        let duration = UserDefaults.standard.string(forKey: "video_duration")!
        let value = Float(duration)
        timeDuration.setValue(value!/60, animated: true)
        self.decideCurTimeText(value: value!/60)
        
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
        let userID = UserDefaults.standard.string(forKey: "user_id")!
        SVProgressHUD.show()
        ApiManager.sharedInstance().updateSetting(userID: userID, video_resolution: resolutionSeg.selectedSegmentIndex, enable_audio: enableAudioSeg.selectedSegmentIndex, video_permission: permissionSeg.selectedSegmentIndex, video_duration: temp_sec, completion: {(simpleModel, strErr) in
            if let strErr = strErr{
                SVProgressHUD.showError(withStatus: strErr)
            }else{
                SVProgressHUD.dismiss()
                if let temp = simpleModel{
                    if temp.status!{
                        UserDefaults.standard.set("\(self.resolutionSeg.selectedSegmentIndex)", forKey: "video_resolution")
                        UserDefaults.standard.set("\(self.enableAudioSeg.selectedSegmentIndex)", forKey: "enable_audio")
                        
                        UserDefaults.standard.set("\(self.permissionSeg.selectedSegmentIndex)", forKey: "video_permission")
                        
                        UserDefaults.standard.set("\(self.temp_sec)", forKey: "video_duration")
                        
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
        
    }
    
    
    @IBAction func getVideoDuration(_ sender: UISlider) {
        self.decideCurTimeText(value: sender.value)

    }
    
    func decideCurTimeText(value: Float){
        let temp = Int(value * 100)
        let mins = "0" + "\(temp/100)" + ":"
        let sec_temp = Float(temp % 100)
        let sec = Int(sec_temp/100 * 60)
        self.temp_sec = sec + temp/100 * 60
        var sec_str = "\(sec)"
        if(sec_str.count < 2){
            sec_str = "0" + sec_str
        }
        self.curDurationLabel.text = mins + sec_str
    }

}
