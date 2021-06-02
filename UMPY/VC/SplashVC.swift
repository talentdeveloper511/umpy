//
//  SplashVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class SplashVC: UIViewController {

    @IBOutlet weak var loader: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.createGradientLayer()
        loader.type = .pacman
        loader.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // change 2 to desired number of seconds
            // Your code with delay
            self.goToNext()
        }
        
    }
    
    func goToNext(){
        let login = UserDefaults.standard.bool(forKey: "IS_LOGIN")
        if(login != nil && login == true){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            self.present(newViewController, animated: true, completion: nil)
        }else{
            
              let terms = UserDefaults.standard.bool(forKey: "IS_TERMS")
            if(terms != nil && terms == true){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.present(newViewController, animated: true, completion: nil)

            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
                newViewController.type = 0
                self.present(newViewController, animated: true, completion: nil)
            }
        }
    }
    

}

extension UIView{
    
    func createGradientLayer(cgRadius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [Constants.startColor.cgColor, Constants.endColor.cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.cornerRadius = cgRadius
        gradientLayer.frame = bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func topCreateGradient(cgRadius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [Constants.startColor.cgColor, Constants.endColor.cgColor]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.cornerRadius = cgRadius
        gradientLayer.frame = bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

