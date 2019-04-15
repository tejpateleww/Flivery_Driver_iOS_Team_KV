//
//  SettingPasscodeVC.swift
//  TickTok User
//
//  Created by Excelent iMac on 05/01/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class SettingPasscodeVC: BaseViewController {

    
    var bottomBorderOfPasscode = CALayer()
    var bottomBorderOfChangePasscode = CALayer()
    var bottomBorderOfProfile = CALayer()
    
    var boolChangePasscode = Bool()
  
    
    @IBOutlet weak var btnSetPassword: UIButton!
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    @IBOutlet weak var btnChangePasssworld: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewChangePasscode.isHidden = true

        if(Singletons.sharedInstance.isPasscodeON)
        {
            self.switchPasscode.isOn = true
            viewChangePasscode.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLocalizable()
        self.setNavBarWithMenuORBack(Title: "Settings".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
    }
    
    func setLocalizable(){
        btnChangePasssworld.setTitle("Change Password".localized, for: .normal)
        btnProfile.setTitle("Profile".localized, for: .normal)
        self.title = "Settings".localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var viewSetPasscode: UIView!
    @IBOutlet weak var viewChangePasscode: UIView!
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var switchPasscode: UISwitch!
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func switchPasscode(_ sender: UISwitch) {
        
        
        if sender.isOn {
            if(Singletons.sharedInstance.setPasscode == "")
            {
                self.switchPasscode.isOn = false
                self.performSegue(withIdentifier: "segueCreatePasscode", sender: nil)
            }
            else
            {
                viewChangePasscode.isHidden = false
                
                Singletons.sharedInstance.isPasscodeON = true
                UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
            }
        }
        else {
            viewChangePasscode.isHidden = true
            
            Singletons.sharedInstance.isPasscodeON = false
            UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")

        }
        
    }
    
    
    @IBAction func btnChangePasscode(_ sender: UIButton) {
        
        boolChangePasscode = true
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueCreatePasscode")
        {
            let setPasscode = segue.destination as! SetPasscodeViewController
            setPasscode.isChangePassword = boolChangePasscode
        }
        //        segueCreatePasscode
        
    }

}
