//
//  BaseViewController.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 05/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {


    var btnDuty = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnDuty = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.btnDuty.backgroundColor = .clear
        self.btnDuty.setImage(UIImage.init(named: "iconSwitchOff"), for: .normal)
        self.btnDuty.setImage(UIImage.init(named: "iconSwitchOn"), for: .selected)
        self.btnDuty.addTarget(self, action:  #selector(self.webserviceForChangeDutyStatus), for: .touchUpInside)

        if(Singletons.sharedInstance.driverDuty == "1")
        {
            self.btnDuty.isSelected = true
        }
        // Do any additional setup after loading the view.
    }
    func setNavBarWithMenuORBack(Title:String,LetfBtn : String, IsNeedRightButton:Bool ,isTranslucent : Bool)
    {
        //        self.navigationController?.navigationBar.isTranslucent = false
        
//        if Title == "Home"
//        {
//            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
//            titleImage.contentMode = .scaleAspectFit
//            titleImage.image = UIImage(named: "Title_logo")
//            //            titleImage.backgroundColor  = themeYellowColor
//            self.navigationItem.titleView = titleImage
//        }
//        else
//        {
            self.navigationItem.title = Title//.uppercased()
//        }
        self.navigationController?.isNavigationBarHidden = false
        //        self.navigationController?.navigationBar.isOpaque = false
        self.navigationController?.navigationBar.barTintColor = ThemeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if LetfBtn == kIconMenu
        {
            let leftNavBarButton = UIBarButtonItem(image: UIImage(named: LetfBtn), style: .plain, target: self, action: #selector(self.OpenMenuAction))
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = leftNavBarButton
            
        }
        else
        {
            let leftNavBarButton = UIBarButtonItem(image: UIImage(named: LetfBtn), style: .plain, target: self, action: #selector(self.btnBackAction))
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = leftNavBarButton
        }
        
        if IsNeedRightButton == true
        {
            let rightNavBarButton = UIBarButtonItem(customView: self.btnDuty)
            
            //UIBarButtonItem(image: UIImage(named: "iconSwitchOff"), style: .plain, target: self, action: #selector(self.btnCallAction))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        if UserDefaults.standard.value(forKey: "i18n_language") != nil
        {
            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if language == "sw" {
                    //                    btnLeft.semanticContentAttribute = .forceLeftToRight
                    
                    //                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
                }
            }
        }
    }
    
    
//    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool){
////        self.navigationController?.navigationBar.isTranslucent = false
//
//        if Title == "Home" {
//            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
//            titleImage.contentMode = .scaleAspectFit
//            titleImage.image = UIImage(named: "Title_logo")
////            titleImage.backgroundColor  = themeYellowColor
//             self.navigationItem.titleView = titleImage
//        } else {
//            self.navigationItem.title = Title.uppercased()
//        }
//        self.navigationController?.isNavigationBarHidden = false
////        self.navigationController?.navigationBar.isOpaque = false
//        self.navigationController?.navigationBar.barTintColor = ThemeYellowColor;
//        self.navigationController?.navigationBar.tintColor = UIColor.white;
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//
//
//        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
//
//        if IsNeedRightButton == true {
//            let rightNavBarButton = UIBarButtonItem(customView: self.btnDuty)
//
//                //UIBarButtonItem(image: UIImage(named: "iconSwitchOff"), style: .plain, target: self, action: #selector(self.btnCallAction))
//            self.navigationItem.rightBarButtonItem = nil
//            self.navigationItem.rightBarButtonItem = rightNavBarButton
//        } else {
//            self.navigationItem.rightBarButtonItem = nil
//        }
//    }
//
//    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool) {
////        self.navigationController?.navigationBar.isTranslucent = false
//
//        if Title == "Home" {
//            let titleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
//            titleImage.contentMode = .scaleAspectFit
//            titleImage.image = UIImage(named: "Title_logo")
//            self.navigationItem.titleView = titleImage
//        } else {
//            self.navigationItem.title = Title.uppercased().localizedUppercase
//        }
//        self.navigationController?.navigationBar.barTintColor = ThemeYellowColor;
//        self.navigationController?.navigationBar.tintColor = UIColor.white;
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.isTranslucent = false
//
//
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconBack"), style: .plain, target: self, action: #selector(self.btnBackAction))
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
//
//
//        if IsNeedRightButton == true {
//
//            let rightNavBarButton = UIBarButtonItem(customView: self.btnDuty)
//                //UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.webserviceForChangeDutyStatus))
//            self.navigationItem.rightBarButtonItem = nil
//            self.navigationItem.rightBarButtonItem = rightNavBarButton
//        } else {
//            self.navigationItem.rightBarButtonItem = nil
//        }
//        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
//            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
//                if language == "sw" {
////                    btnLeft.semanticContentAttribute = .forceLeftToRight
//
////                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
//                }
//            }
//        }
//    }


    //-------------------------------------------------------------
    // MARK: - Webservice For Change Duty Status
    //-------------------------------------------------------------

    @objc func webserviceForChangeDutyStatus()
    {
        let profile = NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile as NSDictionary).object(forKey: "profile") as! NSDictionary)
        let vehicle = profile.object(forKey: "Vehicle") as! NSDictionary

        var dictData = [String:AnyObject]()
        dictData[profileKeys.kDriverId] = vehicle.object(forKey: "DriverId") as AnyObject

        if Singletons.sharedInstance.latitude == nil || Singletons.sharedInstance.longitude == nil || Singletons.sharedInstance.latitude == 0 || Singletons.sharedInstance.longitude == 0
        {
            UtilityClass.showAlert("App Name".localized, message: "Please turn on location", vc: self)
        }
        else
        {

            dictData[RegistrationFinalKeys.kLat] = Singletons.sharedInstance.latitude as AnyObject
            dictData[RegistrationFinalKeys.kLng] = Singletons.sharedInstance.longitude as AnyObject

            webserviceForDriverChangeDutyStatusOrShiftDutyStatus(dictData as AnyObject) { (result, status) in

                if (status) {

                    print(result)
                    self.btnDuty.isEnabled = true

                    if ((result as! NSDictionary).object(forKey: "duty") as! String == "off")
                    {
//                        self.headerView?.btnSwitch.setImage(UIImage(named: "iconSwitchOff"), for: .normal)
                        self.btnDuty.isSelected = false
                        Singletons.sharedInstance.driverDuty = "0"
                        UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                        UIApplication.shared.isIdleTimerDisabled = false
                        let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                        socket.disconnect()

                    }
                    else
                    {
//                        self.headerView?.btnSwitch.setImage(UIImage(named: "iconSwitchOn"), for: .normal)
                        self.btnDuty.isSelected = true
                        Singletons.sharedInstance.driverDuty = "1"

                        let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                        socket.connect()
                        UIApplication.shared.isIdleTimerDisabled = true

                        UtilityClass.showAlert("", message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)

                        let contentVC = (self.navigationController?.children[0] as? TabbarController)?.children[0] as? HomeViewController
                        contentVC?.UpdateDriverLocation()

                    }
                    UserDefaults.standard.set(Singletons.sharedInstance.driverDuty, forKey: "DriverDuty")
                }
                else
                {
                    print(result)


                    if let res = result as? String {
                        UtilityClass.showAlert("App Name".localized, message: res, vc: self)
                    }
                    else if let resDict = result as? NSDictionary {
                        UtilityClass.showAlert("App Name".localized, message: resDict.object(forKey: GetResponseMessageKey()) as! String, vc: self)
                    }
                    else if let resAry = result as? NSArray {
                        UtilityClass.showAlert("App Name".localized, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                    }

                     self.btnDuty.isEnabled = true


                }
            }
        }
    }
    
    // MARK:- Navigation Bar Button Action Methods
    
    @objc func OpenMenuAction(){
        sideMenuController?.revealMenu(animated: true, completion: nil)
    }
    
    @objc func btnBackAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCallAction() {
        
        let contactNumber =  WebSupport.HelplineNumber
        if contactNumber == "" {
            UtilityClass.showAlertWithCompletion(appName.kAPPName, message: "Contact number is not available", vc: self) { (status) in

            }

        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
