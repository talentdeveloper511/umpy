//
//  EditProfileVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {


    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var surName: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var homCity: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var topBarView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadUI()
        
        firstName.text = UserDefaults.standard.string(forKey: "first_name")
        surName.text = UserDefaults.standard.string(forKey: "sec_name")
        emailText.text = UserDefaults.standard.string(forKey: "email")
        homCity.text = UserDefaults.standard.string(forKey: "home_city")
        country.text = UserDefaults.standard.string(forKey: "country")
        phoneNum.text = UserDefaults.standard.string(forKey: "phone")
        
    }
    func loadUI(){
      
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
        dismiss(animated: true, completion: nil)
    }
    @IBAction func changePassword(_ sender: Any) {

    }

    @IBAction func save(_ sender: Any) {
        let alert = UIAlertController(title: "Message",
                                      message: "Successfully saved.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
