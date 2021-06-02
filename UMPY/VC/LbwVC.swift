//
//  LbwVC.swift
//  UMPY
//
//  Created by CBDev on 3/21/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import UIKit
import BottomPopup
class LbwVC: BottomPopupViewController {
    @IBOutlet weak var question1: UILabel!
    @IBOutlet weak var question2: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var displayResult = ""
    var backIndex1 = 0
    var backIndex2 = 0
    var backOn1 = false
    var backOn2 = false
    @IBOutlet weak var decisionText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.createGradientLayer()
        
        question1.text = Constants.lbwStrArr1[0]
        question2.text = Constants.lbwStrArr2[0]
        
    }
    
    @IBAction func clickFirstYes(_ sender: Any) {
//        view1.isHidden = true
        backOn1 = false
        if(question1.text == Constants.lbwStrArr1[0]){
            question1.text = Constants.lbwStrArr1[1]
            backIndex1 = 0
        }else if(question1.text == Constants.lbwStrArr1[1]){
            displayResult = "No Ball. Not Out."
            decisionText.text = displayResult
            backIndex1 = 1
        }else if(question1.text == Constants.lbwStrArr1[2]){
            question1.text = Constants.lbwStrArr1[3]
            backIndex1 = 2
        }else if(question1.text == Constants.lbwStrArr1[3]){
            displayResult = "Out Caught."
            decisionText.text = displayResult
            backIndex1 = 3
        }else{
            displayResult = "Out LBW."
            decisionText.text = displayResult
            backIndex1 = 2
        }
    }
    @IBAction func clickFirstNo(_ sender: Any) {
//        view1.isHidden = true
        backOn1 = false
        if(question1.text == Constants.lbwStrArr1[0]){
            displayResult = "No Ball. Not Out."
            decisionText.text = displayResult
             backIndex1 = 0
        }else if(question1.text == Constants.lbwStrArr1[1]){
            question1.text = Constants.lbwStrArr1[2]
            backIndex1 = 1
        }else if(question1.text == Constants.lbwStrArr1[2]){
            question1.text = Constants.lbwStrArr1[4]
            backIndex1 = 2
        }else if(question1.text == Constants.lbwStrArr1[3]){
            displayResult = "Not Out."
            decisionText.text = displayResult
            backIndex1 = 3
        }else{
            dismiss(animated: true, completion: nil)
        }

    }
    
    @IBAction func clickSecYes(_ sender: Any) {
        backOn2 = false
//        view2.isHidden = true
        if(question2.text == Constants.lbwStrArr2[0]){
            displayResult = "Not Out"
            decisionText.text = displayResult
            backIndex2 = 0
        }else if(question2.text == Constants.lbwStrArr2[1]){
            dismiss(animated: true, completion: nil)
            backIndex2 = 1
        }else if(question2.text == Constants.lbwStrArr2[2]){
            question2.text = Constants.lbwStrArr2[4]
            backIndex2 = 2
        }else if(question2.text == Constants.lbwStrArr2[3]){
            displayResult = "Out LBW."
            decisionText.text = displayResult
            backIndex2 = 3
        }
        else{
            displayResult = "Out LBW."
            decisionText.text = displayResult
            backIndex2 = 2
        }
    }
    
    @IBAction func clickSecNo(_ sender: Any) {
//        view2.isHidden = true
        backOn2 = false
        if(question2.text == Constants.lbwStrArr2[0]){
            question2.text = Constants.lbwStrArr2[1]
            backIndex2 = 0
        }else if(question2.text == Constants.lbwStrArr2[1]){
            question2.text = Constants.lbwStrArr2[2]
            backIndex2 = 1
        }else if(question2.text == Constants.lbwStrArr2[2]){
            question2.text = Constants.lbwStrArr2[3]
            backIndex2 = 2
        }else if(question2.text == Constants.lbwStrArr2[3]){
            displayResult = "Not Out."
            decisionText.text = displayResult
            backIndex2 = 3
        }
        else{
            displayResult = "Not Out."
            decisionText.text = displayResult
            backIndex2 = 2
        }
    }
    
    @IBAction func backQuiz(_ sender: Any) {
        self.decisionText.text = "LBW WIZARD Decision"
        if(backOn1){
            if(backIndex1 > 0){
                self.question1.text = Constants.lbwStrArr1[backIndex1 - 1]
            }
        }else{
            self.question1.text = Constants.lbwStrArr1[backIndex1]
            self.backOn1 = true
        }
        
        if(backOn2){
            if(backIndex2 > 0){
                self.question2.text = Constants.lbwStrArr1[backIndex2 - 1]
            }
        }else{
            self.question2.text = Constants.lbwStrArr2[backIndex2]
            self.backOn2 = true
        }
        
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func getPopupHeight() -> CGFloat {
        return UIScreen.main.bounds.height * 0.4
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return  CGFloat(10)
    }
    
    override func getPopupPresentDuration() -> Double {
        return 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return true
    }

    
}
