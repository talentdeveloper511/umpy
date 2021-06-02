//
//  PairDeviceVC.swift
//  UMPY
//
//  Created by CBDev on 3/13/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class PairDeviceVC: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var deviceTable: UITableView!
    
    @IBOutlet weak var scanLoadingView: NVActivityIndicatorView!
    
    @IBOutlet weak var scanLabel: UILabel!
    
    
    var deviceList:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      
        scanLabel.text = "Scanning..."
        scanLoadingView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.scanLoadingView.stopAnimating()
            self.scanLabel.text = "Detected Devices"
            self.deviceList = ["UMPY1", "UMPY Tester", "UMPY2"]
            self.deviceTable.reloadData()
            
        }
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
    
    @IBAction func startMatch(_ sender: Any) {
        goCameraView()
    }
    
    @IBAction func skipPair(_ sender: Any) {
        goCameraView()
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func goCameraView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}

extension PairDeviceVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        
        cell.deviceName.text = deviceList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    
}
