//
//  ContactVC.swift
//  UMPY
//
//  Created by CBDev on 3/20/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import MessageUI
class ContactVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var topBarView: UIView!
    var email = "umpity@support.com"
    var phoneNumber = "456123456"
    var website = "http://www.umpy.com"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.email])
            mail.setMessageBody("<p>Contact Support</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Error")
        }
    }
    
    @IBAction func goToWebsite(_ sender: Any) {
        guard let url = URL(string: website) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    

    @IBAction func call(_ sender: Any) {
        let phoneStr = "tel://" + self.phoneNumber
        print(phoneStr)
        if let url = URL(string: "tel://96454584"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }    }
    
}
