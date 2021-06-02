//
//  SignUpVC.swift
//  UMPY
//
//  Created by CBDev on 3/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import CountryPickerView
import SVProgressHUD
import CoreLocation
import FirebaseAuth
import Toast_Swift
class SignUpVC: UIViewController, CLLocationManagerDelegate, DigitInputViewDelegate {


    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var homecityText: UITextField!
    
    @IBOutlet weak var securityQ1: UILabel!
    @IBOutlet weak var securityQA1: UITextField!
    @IBOutlet weak var securityQ2: UILabel!
    @IBOutlet weak var securityQA2: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var countryText: UITextField!

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var containerView: UIView!
    let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    let cpvCountry = CountryPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width - 32, height: 20))
    let locationManager = CLLocationManager()
    var latitude: String = "0.0"
    var longitude: String = "0.0"
    
    @IBOutlet weak var userType: UISegmentedControl!
    
    @IBOutlet weak var verifyCodeText: DigitInputView!
    
    var verifyCode = "0000"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        verifyCodeText.delegate = self
        setUpUI()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        makeSecurity()
        
    }
    
    func makeSecurity(){
        let num1 = Int.random(in: 0 ..< 40)
        var num2 = Int.random(in: 0 ..< 40)
        if(num1 == num2){
           num2 = Int.random(in: 0 ..< 40)
        }
        self.securityQ1.text = Constants.securityQuiz[num1]
        self.securityQ2.text = Constants.securityQuiz[num2]
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = "\(locValue.latitude)"
        longitude = "\(locValue.longitude)"
    }
    
    func setUpUI(){
        self.view.createGradientLayer()
        containerView.createGradientLayer()
        verifyView.createGradientLayer()
        verifyView.isHidden = true
        signUpBtn.layer.cornerRadius = 4
        
        phoneText.leftView = cpv
        phoneText.leftViewMode = .always
        
        cpvCountry.showPhoneCodeInView = false
        countryText.leftView = cpvCountry
        countryText.leftViewMode = .always
        
        
        verifyCodeText.bottomBorderColor = .white
        verifyCodeText.nextDigitBottomBorderColor = .red
        verifyCodeText.textColor = .white
        verifyCodeText.acceptableCharacters = "0123456789"
        verifyCodeText.keyboardType = .decimalPad
        verifyCodeText.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 1))
        verifyCodeText.animationType = .spring
        verifyCodeText.keyboardAppearance = .dark
    }
    
    @IBAction func hideVerifyView(_ sender: Any) {
        verifyView.isHidden = true
        
    }
    @IBAction func signUP(_ sender: Any) {
        if(getValidate()){
            
            if(self.passwordText.text == self.confirmPassword.text){
                if(passwordText.text!.count > 5){
                    
                    SVProgressHUD.show()
                    ApiManager.sharedInstance().verifyPhone(phoneNum: cpvCountry.selectedCountry.phoneCode + self.phoneText.text!, completion: {(simpleModel, strErr) in
                        if let strErr = strErr{
                            SVProgressHUD.showError(withStatus: strErr)
                        }else{
                            SVProgressHUD.dismiss()
                            if let temp = simpleModel{
                                if(temp.status!){
                                    self.verifyCode = temp.data!
                                    self.verifyView.isHidden = false
                                    self.verifyCodeText.becomeFirstResponder()
                                }else{
                                    self.containerView.makeToast("Failed to send sms.")
                                }
                            }
                        }
                    })
                }
                else{
                    let alert = UIAlertController(title: "Sign Up Failed",
                                                  message: "Password should be 6+ character.",
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
            else{
                let alert = UIAlertController(title: "Sign Up Failed",
                                              message: "Please confirm your password.",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }else{
            let alert = UIAlertController(title: "Sign Up Failed",
                                          message: "Please fill out forms",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func registerUser(){
        SVProgressHUD.show()
        var user_type = "user"
        if(userType.selectedSegmentIndex == 1){
            user_type = "team"
        }
        ApiManager.sharedInstance().signup_user(firstName: firstNameText.text!, secName: surnameText.text!, email: emailText.text!, country: cpvCountry.selectedCountry.code, home_city: homecityText.text!, phone_num: cpv.selectedCountry.phoneCode + phoneText.text!, password: passwordText.text!, user_type: user_type, latitude: latitude, longitude: longitude, completion: {(userModel, strErr ) in
            
            if let strErr = strErr {
                SVProgressHUD.showError(withStatus: strErr)
            }else{
                if let userModel = userModel{
                    if(userModel.status! == true){
                        self.saveData(user: userModel)
                        ApiManager.sharedInstance().addSecurityQuestion(userID: userModel.id!, question1: self.securityQ1.text!, answer1: self.securityQA1.text!, question2: self.securityQ2.text!, answer2: self.securityQA2.text!, completion: {(simpleModel, strErr) in
                            if let strErr = strErr{
                                SVProgressHUD.showError(withStatus: strErr)
                            }else{
                                SVProgressHUD.dismiss()
                                UserDefaults.standard.set(self.securityQ1.text!, forKey: "question1")
                                UserDefaults.standard.set(self.securityQ2.text!, forKey: "question2")
                                UserDefaults.standard.set(self.securityQA1.text!, forKey: "answer1")
                                UserDefaults.standard.set(self.securityQA2.text!, forKey: "answer2")
                                self.goToMain()
                            }
                        })
                    }else{
                        let alert = UIAlertController(title: "Umpity",
                                                      message: "Sign Up failed.",
                                                      preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    

    
    func goToMain(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func getValidate() -> Bool{
        if(self.firstNameText.text == nil || self.firstNameText.text == ""){
            return false
        }
        if(self.surnameText.text == nil || self.surnameText.text == ""){
            return false
        }
        if(self.homecityText.text == nil || self.homecityText.text == ""){
            return false
        }
        if(self.phoneText.text == nil || self.phoneText.text == ""){
            return false
        }
        if(self.firstNameText.text == nil || self.firstNameText.text == ""){
            return false
        }
        
        if(!isValidEmail(testStr: self.emailText.text!)){
            return false
        }
        
        if(self.passwordText.text == nil || self.passwordText.text == ""){
            return false
        }
        
        if(self.confirmPassword.text == nil || self.confirmPassword.text == ""){
            return false
        }
        
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func saveData(user: UserModel){
        UserDefaults.standard.set(user.id, forKey: "user_id")
        UserDefaults.standard.set(user.firstName, forKey: "first_name")
        UserDefaults.standard.set(user.secName, forKey: "sec_name")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(passwordText.text, forKey: "password")
        UserDefaults.standard.set(user.phoneNum, forKey: "phone")
        UserDefaults.standard.set(user.country, forKey: "country")
        UserDefaults.standard.set(user.home_city, forKey: "home_city")
        UserDefaults.standard.set(user.latitude, forKey: "latitude")
        UserDefaults.standard.set(user.longitude, forKey: "longitude")
        UserDefaults.standard.set(user.user_type, forKey: "user_type")
        
        
        UserDefaults.standard.set(1, forKey: "video_resolution")
        UserDefaults.standard.set(180, forKey: "video_duration")
        UserDefaults.standard.set(1, forKey: "enable_audio")
        UserDefaults.standard.set(1, forKey: "video_permission")
        
    }
    
    func digitsDidChange(digitInputView: DigitInputView) {
        print("changed")
    }
    
    func digitsDidFinish(digitInputView: DigitInputView) {
        if digitInputView.text == self.verifyCode{
            registerUser()
        }else{
            self.verifyView.makeToast("Verification Failed. Wrong code. Please try again.")
        }
    }
    
    
}
