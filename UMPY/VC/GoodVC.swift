//
//  GoodVC.swift
//  UMPY
//
//  Created by CBDev on 3/21/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class GoodVC: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var checkbox1: Checkbox!
    @IBOutlet weak var checkbox2: Checkbox!
    @IBOutlet weak var checkbox3: Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topBarView.topCreateGradient()
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.topBarView.frame
        rectShape.position = self.topBarView.center
        rectShape.path = UIBezierPath(roundedRect: self.topBarView.bounds, byRoundingCorners: [.bottomLeft ], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.topBarView.layer.mask = rectShape
        
        checkbox1.checkmarkColor = Constants.startColor
        checkbox1.checkmarkStyle = .tick
        checkbox1.borderStyle = .circle
        checkbox1.checkedBorderColor = Constants.startColor
        checkbox1.uncheckedBorderColor = Constants.primaryColor
        checkbox1.isChecked = true
        
        
        checkbox2.checkmarkColor = Constants.startColor
        checkbox2.checkmarkStyle = .tick
        checkbox2.borderStyle = .circle
        checkbox2.checkedBorderColor = Constants.startColor
        checkbox2.uncheckedBorderColor = Constants.primaryColor
        
        
        checkbox3.checkmarkColor = Constants.startColor
        checkbox3.checkmarkStyle = .tick
        checkbox3.borderStyle = .circle
        checkbox3.checkedBorderColor = Constants.startColor
        checkbox3.uncheckedBorderColor = Constants.primaryColor
        
        
        
    }
    @IBAction func backTo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func goRecord(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
