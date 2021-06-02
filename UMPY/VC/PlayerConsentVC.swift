//
//  PlayerConsentVC.swift
//  UMPY
//
//  Created by CBDev on 3/21/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class PlayerConsentVC: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "CONSENT TO RECORD"
        view2.isHidden = true
        view1.isHidden = false
        

        // corner radius
        view1.layer.cornerRadius = 6
        
        // border
        view1.layer.borderWidth = 1.0
        view1.layer.borderColor = UIColor.white.cgColor
        
        // shadow
        view1.layer.shadowColor = UIColor.lightGray.cgColor
        view1.layer.shadowOffset = CGSize(width: 2, height: 2)
        view1.layer.shadowOpacity = 0.7
        view1.layer.shadowRadius = 4.0
        
        // corner radius
        view2.layer.cornerRadius = 6
        
        // border
        view2.layer.borderWidth = 1.0
        view2.layer.borderColor = UIColor.white.cgColor
        
        // shadow
        view2.layer.shadowColor = UIColor.lightGray.cgColor
        view2.layer.shadowOffset = CGSize(width: 2, height: 2)
        view2.layer.shadowOpacity = 0.7
        view2.layer.shadowRadius = 4.0
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
    
    @IBAction func next(_ sender: Any) {
        if(titleLabel.text == "CONSENT TO RECORD")
        {
            view2.isHidden = false
            view1.isHidden = true
            titleLabel.text = "Confirmation of Consent"
        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "GoodVC") as! GoodVC
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    @IBAction func backTo(_ sender: Any) {
        if(titleLabel.text == "CONSENT TO RECORD")
        {
            dismiss(animated: true, completion: nil)
        }else{
            view2.isHidden = true
            view1.isHidden = false
            titleLabel.text = "CONSENT TO RECORD"
        }
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
