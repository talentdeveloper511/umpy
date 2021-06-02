//
//  AboutUsVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        
        
        
        // corner radius
        containerView.layer.cornerRadius = 6
        
        // border
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.white.cgColor
        
        // shadow
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 4.0
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
    


}
