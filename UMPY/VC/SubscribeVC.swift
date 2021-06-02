//
//  SubscribeVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class SubscribeVC: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    func setUpUI(){

        
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
