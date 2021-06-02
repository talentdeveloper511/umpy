//
//  MatchesVC.swift
//  UMPY
//
//  Created by CBDev on 3/21/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import SVProgressHUD
import Toast_Swift
class MatchesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarView: UIView!
    
    var matchList: [Match] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMatchData()
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
    
    func loadMatchData(){
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        SVProgressHUD.show()
        
        ApiManager.sharedInstance().getMatches(userID: user_id!, completion: {(matchArr, strErr) in
            if let strErr = strErr {
                SVProgressHUD.showError(withStatus: strErr)
            }else{
                SVProgressHUD.dismiss()
                
                if let list = matchArr{
                    if list.status == true {
                        self.matchList = list.list!
                        self.tableView.reloadData()
                    }
                    
                }
            }
        })
        
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MatchesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
        let match = matchList[indexPath.row]
        cell.matchTime.text = match.date
        cell.teamName.text = match.home_team
        // corner radius
        cell.containerView.layer.cornerRadius = 6
        
        // border
        cell.containerView.layer.borderWidth = 1.0
        cell.containerView.layer.borderColor = UIColor.white.cgColor
        
        // shadow
        cell.containerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.containerView.layer.shadowOpacity = 0.7
        cell.containerView.layer.shadowRadius = 4.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let match = self.matchList[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VideoListVC") as! VideoListVC
        newViewController.match_id = match.id!
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let match = self.matchList[indexPath.row]
            SVProgressHUD.show()
            ApiManager.sharedInstance().deleteMatch(matchID: match.id!, completion: {(simpleModel, strErr) in
                if let strErr = strErr{
                    SVProgressHUD.showError(withStatus: strErr)
                }else{
                    SVProgressHUD.dismiss()
                    self.view.makeToast("Succesfully deleted.")
                    self.loadMatchData()
                }
            })
        }
    }
    
}
