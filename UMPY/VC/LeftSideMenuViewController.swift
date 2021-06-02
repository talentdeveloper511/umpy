//
//  LeftSideMenuViewController.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    let menuLabels:[String] = ["Main", "Matches", "Settings", "Player Consent", "Subscribe", "About us", "Terms agreement", "Privacy Policy", "Contact", "Sign Out"]
    
   var selectedId:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedId = -1
    }
    
    @IBAction func editProfile(_ sender: Any) {
        self.selectedId = 100
        dismiss(animated: true, completion: nil)
    }
    
}

extension LeftSideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath) as! MenuItem
        
        cell.menuLabel.text = self.menuLabels[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedId = indexPath.row
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
