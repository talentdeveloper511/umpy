//
//  SignInVC.swift
//  UMPY
//
//  Created by CBDev on 3/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift
class SignInVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInFBBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signInBtn.layer.cornerRadius = 4
        signInFBBtn.layer.cornerRadius = 4
        self.view.createGradientLayer()
    }
    
    
    @IBAction func signIn(_ sender: Any) {

    }
    
    
    @IBAction func logIn(_ sender: Any) {
        if(getValidate()){
            SVProgressHUD.show()
            ApiManager.sharedInstance().login(email: usernameText.text!, password: passwordText.text!, completion: {(userModel, strErr) in
                
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    SVProgressHUD.dismiss()
                    
                    if let userModel = userModel{
                        if(userModel.status!){
                            
                            UserDefaults.standard.set(true, forKey: "IS_LOGIN")
                            UserDefaults.standard.set(userModel.id, forKey: "user_id")
                            UserDefaults.standard.set(userModel.firstName, forKey: "first_name")
                            UserDefaults.standard.set(userModel.secName, forKey: "sec_name")
                            UserDefaults.standard.set(userModel.email, forKey: "email")
                            UserDefaults.standard.set(userModel.country, forKey: "country")
                            UserDefaults.standard.set(userModel.home_city, forKey: "home_city")
                            UserDefaults.standard.set(userModel.phoneNum, forKey: "phone")
                            UserDefaults.standard.set(userModel.user_type, forKey: "user_type")
                            
                            self.getSetting()
                        }else{
                            let alert = UIAlertController(title: "Umpity", message: "Login Failed, Please input correct info.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                        }
                    }
                }
            })
            

        }else{
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: "Please fill Out your forms.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getSetting(){
        let video_resolution =  UserDefaults.standard.string(forKey: "video_resolution")
        if(video_resolution != nil && video_resolution != ""){
            self.goToMain()
        }else{
            SVProgressHUD.show()
            let userID = UserDefaults.standard.string(forKey: "user_id")
            ApiManager.sharedInstance().getSetting(userID: userID!, completion: {(settingModel, strErr) in
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
                            self.goToMain()
                        
                        }else{
                            self.view.makeToast("Can't get setting information")
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func signInWithFB(_ sender: Any) {
        goToMain()
    }
    
    func goToMain(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func getValidate() -> Bool{
        
        if(!isValidEmail(testStr: usernameText.text ?? "")){
            return false
        }
        
        if(passwordText.text == nil || passwordText.text == ""){
            return false
        }
        
        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBAction func goToPrivacy(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        newViewController.type = 2
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func goToTerms(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        newViewController.type = 1
        self.present(newViewController, animated: true, completion: nil)
    }
}
