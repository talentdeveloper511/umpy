//
//  WebVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class WebVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backBtn: UIButton!
    var type: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        
        SVProgressHUD.show()
        webView.navigationDelegate = self
        setUpUI()
    }
    func setUpUI(){
        
        var request = ""
        switch type {
        case 0:
            titleLabel.text = "Terms of Use"
            acceptBtn.isHidden = false
            request = "https://umpity.com/terms?"
            backBtn.isHidden = true
            break
        case 1:
            titleLabel.text = "Terms of Use"
            acceptBtn.isHidden = true
            backBtn.isHidden = false
            request = "https://umpity.com/terms?"
            break
        case 2:
            titleLabel.text = "Privacy Policy"
            acceptBtn.isHidden = true
            backBtn.isHidden = false
            request = "https://umpity.com/terms?"
            break
        case 3:
            break
            
        default:
            break
        }
        
        request = "https://gustavoarreaza.com/umpity/"
        webView.load(URLRequest(url: URL(string: request)!))
        
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

    @IBAction func acceptTerms(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "IS_TERMS")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    
}
