//
//  StartMatchVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
import NextLevel
import AVFoundation
import Photos
class StartMatchVC: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    
    @IBOutlet weak var homeTeam: UITextField!
    @IBOutlet weak var visitors: UITextField!
    
    @IBOutlet weak var venue: UITextField!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        view1.layer.cornerRadius = 6
        view1.layer.borderWidth = 1.0
        view1.layer.borderColor = UIColor.white.cgColor
        view1.layer.shadowColor = UIColor.lightGray.cgColor
        view1.layer.shadowOffset = CGSize(width: 2, height: 2)
        view1.layer.shadowOpacity = 0.7
        view1.layer.shadowRadius = 4.0
        
        view2.layer.cornerRadius = 6
        view2.layer.borderWidth = 1.0
        view2.layer.borderColor = UIColor.white.cgColor
        view2.layer.shadowColor = UIColor.lightGray.cgColor
        view2.layer.shadowOffset = CGSize(width: 2, height: 2)
        view2.layer.shadowOpacity = 0.7
        view2.layer.shadowRadius = 4.0
        
        view3.layer.cornerRadius = 6
        view3.layer.borderWidth = 1.0
        view3.layer.borderColor = UIColor.white.cgColor
        view3.layer.shadowColor = UIColor.lightGray.cgColor
        view3.layer.shadowOffset = CGSize(width: 2, height: 2)
        view3.layer.shadowOpacity = 0.7
        view3.layer.shadowRadius = 4.0
        
        view4.layer.cornerRadius = 6
        view4.layer.borderWidth = 1.0
        view4.layer.borderColor = UIColor.white.cgColor
        view4.layer.shadowColor = UIColor.lightGray.cgColor
        view4.layer.shadowOffset = CGSize(width: 2, height: 2)
        view4.layer.shadowOpacity = 0.7
        view4.layer.shadowRadius = 4.0
        
        view5.layer.cornerRadius = 6
        view5.layer.borderWidth = 1.0
        view5.layer.borderColor = UIColor.white.cgColor
        view5.layer.shadowColor = UIColor.lightGray.cgColor
        view5.layer.shadowOffset = CGSize(width: 2, height: 2)
        view5.layer.shadowOpacity = 0.7
        view5.layer.shadowRadius = 4.0
        
        view6.layer.cornerRadius = 6
        view6.layer.borderWidth = 1.0
        view6.layer.borderColor = UIColor.white.cgColor
        view6.layer.shadowColor = UIColor.lightGray.cgColor
        view6.layer.shadowOffset = CGSize(width: 2, height: 2)
        view6.layer.shadowOpacity = 0.7
        view6.layer.shadowRadius = 4.0
        
        view7.layer.cornerRadius = 6
        view7.layer.borderWidth = 1.0
        view7.layer.borderColor = UIColor.white.cgColor
        view7.layer.shadowColor = UIColor.lightGray.cgColor
        view7.layer.shadowOffset = CGSize(width: 2, height: 2)
        view7.layer.shadowOpacity = 0.7
        view7.layer.shadowRadius = 4.0
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
//            NextLevel.requestAuthorization(forMediaType: AVMediaType.video)
//            NextLevel.requestAuthorization(forMediaType: AVMediaType.audio)
        }
        
        authorizePhotoLibaryIfNecessary()
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
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        if(getValidate()){
            SVProgressHUD.show()
            ApiManager.sharedInstance().addMatch(userID: user_id!, home_team: homeTeam.text!, visitors: visitors.text!, venue: venue.text!, grade: grade.text!, date: dateText.text!, completion: {(simpleModel, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }
                else{
                    SVProgressHUD.dismiss()
                    if simpleModel?.status == true{
                        UserDefaults.standard.set(simpleModel?.data, forKey: "current_match_id")
                        self.goPairVC()
                    }
                    else{
                        SVProgressHUD.showError(withStatus: "Can't Create the Match")
                    }
                }
                
            })
            

        }
        
    }
    
    func getValidate() -> Bool{
        
        if(homeTeam.text == nil || homeTeam.text == ""){
            return false
        }
        if(visitors.text == nil || visitors.text == ""){
            return false
        }
        if(venue.text == nil || venue.text == ""){
            return false
        }
        if(grade.text == nil || grade.text == ""){
            return false
        }
        if(dateText.text == nil || dateText.text == ""){
            return false
        }
        
        
        
        return true
    }
    
    @IBAction func skipStartMatch(_ sender: Any) {
        goPairVC()
    }
    
    
    func goPairVC(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func getMatchDate(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(StartMatchVC.startDatePickerValueChanged), for: .valueChanged)
    }
    @objc func startDatePickerValueChanged(_sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        startDate.text = dateFormatter.string(from: _sender.date)
        
    
        
        
    }

}
