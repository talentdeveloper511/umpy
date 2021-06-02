//
//  ChangePasswordVC.swift
//  UMPY
//
//  Created by CBDev on 4/9/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
class ChangePasswordVC: UIViewController {
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if(getValidate()){
            SVProgressHUD.show()
           let userID = UserDefaults.standard.string(forKey: "user_id")
            ApiManager.sharedInstance().updatePassword(userID: userID!, newPassword: self.passwordInput.text!, completion: {(simpleModel, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    SVProgressHUD.dismiss()
                    if let temp = simpleModel{
                        if(temp.status!){
                            let alert = UIAlertController(title: "Umpity",
                                                          message: "Successfully updated",
                                                          preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "Umpity",
                                                          message: "Update Password Failed, Please try again later.",
                                                          preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
        }else{
            let alert = UIAlertController(title: "Umpity",
                                          message: "Input exact password.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getValidate() -> Bool{
        if(self.passwordInput.text == nil || self.passwordInput.text == ""){
            return false
        }
        
        if(self.passwordInput.text != self.confirmPassword.text){
            return false
        }
        
        return true
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

}
