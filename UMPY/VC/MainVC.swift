//
//  MainVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMobileAds
class MainVC: UIViewController, UISideMenuNavigationControllerDelegate {


    var interstitial: GADInterstitial!
    @IBOutlet weak var welcomeTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = GADInterstitial(adUnitID: Constants.admob_interstitial_test)
        let request = GADRequest()
        interstitial.load(request)
        
        interstitial.delegate = self
        // Do any additional setup after loading the view.
        self.view.createGradientLayer()
        let firstName = UserDefaults.standard.string(forKey: "first_name")
        let surName = UserDefaults.standard.string(forKey: "sec_name")
        if(firstName != nil && firstName != ""){
            let name = firstName! + " " + surName!
            welcomeTitle.text = "Welcome " + name
        }else{
            welcomeTitle.text = "Welcome John!"
        }
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    
    @IBAction func resumeMatch(_ sender: Any) {
           goCameraView()
    }
    
    
    @IBAction func startMatch(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "current_match_id")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "StartMatchVC") as! StartMatchVC
        self.present(newViewController, animated: true, completion: nil)
    }
    func goCameraView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as? UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = nil
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
    }
    
    func logOut(){
        
        UserDefaults.standard.set("", forKey: "first_name")
        UserDefaults.standard.set("", forKey: "sur_name")
        UserDefaults.standard.set("", forKey: "email")
        
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set("", forKey: "phone")
        UserDefaults.standard.set("", forKey: "country")
        UserDefaults.standard.set("", forKey: "home_city")
        
        UserDefaults.standard.set(false, forKey: "IS_LOGIN")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.present(newViewController, animated: true, completion: nil)
    }
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        if let vc = menu.topViewController as? LeftSideMenuViewController {
            
            switch (vc.selectedId)
            {
            case 0:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                self.present(newViewController, animated: true, completion: nil)
                break;
            case 1:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "MatchesVC") as! MatchesVC
                self.present(newViewController, animated: true, completion: nil)
                break;
            case 2:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                self.present(newViewController, animated: true, completion: nil)
                break;
            case 3:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlayerConsentVC") as! PlayerConsentVC
                self.present(newViewController, animated: true, completion: nil)
                break;
            case 4:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SubscribeVC") as! SubscribeVC
                self.present(newViewController, animated: true, completion: nil)
                break;
            case 5:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                self.present(newViewController, animated: true, completion: nil)
                break
            case 6:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
                newViewController.type = 1
                self.present(newViewController, animated: true, completion: nil)
                break
            case 7:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
                newViewController.type = 2
                self.present(newViewController, animated: true, completion: nil)
                break
            case 8:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
                self.present(newViewController, animated: true, completion: nil)
                break
            case 9:
                let alert = UIAlertController(title: "Message",
                                              message: "Do you want to sign out really?",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default ){
                    UIAlertAction in
                    self.logOut()
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ))
                
                self.present(alert, animated: true, completion: nil)


                break
            case 100:
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
                self.present(newViewController, animated: true, completion: nil)
                break
                
            default:
                break;
            }
        }
    }

}


extension MainVC: GADInterstitialDelegate {
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
