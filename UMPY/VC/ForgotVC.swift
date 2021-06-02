//
//  ForgotVC.swift
//  UMPY
//
//  Created by CBDev on 3/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
class ForgotVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var securityQView: UIView!
    
    @IBOutlet weak var question1: UILabel!
    @IBOutlet weak var answer1: UITextField!
    @IBOutlet weak var question2: UILabel!
    @IBOutlet weak var answer2: UITextField!
    
    var secOption = false
    var answer1Val = ""
    var answer2Val = ""
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.createGradientLayer()
        
        userID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        if(userID != nil && userID != ""){
            secOption = true
            question1.text = UserDefaults.standard.string(forKey: "question1")
            question2.text = UserDefaults.standard.string(forKey: "question2")
            
            answer1Val = UserDefaults.standard.string(forKey: "answer1")!
            answer2Val = UserDefaults.standard.string(forKey: "answer2")!
        }
    }
    
    @IBAction func selectOption(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            emailText.isHidden = false
            sendBtn.isHidden = false
            securityQView.isHidden = true
        }else{
            if(secOption){
                emailText.isHidden = true
                sendBtn.isHidden = true
                securityQView.isHidden = false
            }else{
                let alert = UIAlertController(title: "Umpity", message: "Can't use this option!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func sendCodeViaEmail(_ sender: Any) {
        if(isValidEmail(testStr: self.emailText.text!)){
            SVProgressHUD.show()
            ApiManager.sharedInstance().forgotPassword(email: self.emailText.text!, completion: {(simpleModel, strErr) in
                if let strErr = strErr {
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    SVProgressHUD.dismiss()
                    if(simpleModel?.status == true){
                        let alert = UIAlertController(title: "Umpity", message: "Sent the new password to your email.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                }
                
            })
        }else{
            let alert = UIAlertController(title: "Umpity", message: "Input exact email!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func confirmSecurityQ(_ sender: Any) {
        if(answer1.text == answer1Val && answer2.text == answer2Val){
            SVProgressHUD.show()
            ApiManager.sharedInstance().getSetting(userID: self.userID, completion: {(settingModel, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    SVProgressHUD.dismiss()
                    if let settingInfo = settingModel{
                        if(settingInfo.status!){
                            UserDefaults.standard.set(settingInfo.videoResolution, forKey: "video_resolution")
                            UserDefaults.standard.set(settingInfo.videoDuration, forKey: "video_duration")
                            UserDefaults.standard.set(settingInfo.enableAudio, forKey: "enable_audio")
                            UserDefaults.standard.set(settingInfo.videoPermission, forKey: "video_permission")
                            
                            ApiManager.sharedInstance().getUserInfo(userID: self.userID, completion: {(userModel, strErr) in
                                if let strErr = strErr{
                                    SVProgressHUD.showError(withStatus: strErr)
                                }else{
                                    SVProgressHUD.dismiss()
                                    if let userModel = userModel{
                                        self.saveData(user: userModel)
                                        self.goToMain()
                                    }
                                }
                            })
                        }else{
                            self.view.makeToast("Can't get setting information")
                        }
                    }
                }
            })
        }else{
            let alert = UIAlertController(title: "Umpity", message: "Authorization Failed!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func saveData(user: UserModel){
        UserDefaults.standard.set(user.firstName, forKey: "first_name")
        UserDefaults.standard.set(user.secName, forKey: "sec_name")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.phoneNum, forKey: "phone")
        UserDefaults.standard.set(user.country, forKey: "country")
        UserDefaults.standard.set(user.home_city, forKey: "home_city")
        UserDefaults.standard.set(user.latitude, forKey: "latitude")
        UserDefaults.standard.set(user.longitude, forKey: "longitude")
        UserDefaults.standard.set(user.user_type, forKey: "user_type")
        
    }
    
    func goToMain(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.present(newViewController, animated: true, completion: nil)
    }
}
