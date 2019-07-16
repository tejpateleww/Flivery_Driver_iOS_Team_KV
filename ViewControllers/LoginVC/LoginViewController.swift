 //
 //  LoginViewController.swift
 //  TiCKTOC-Driver
 //
 //  Created by Excellent Webworld on 12/10/17.
 //  Copyright © 2017 Excellent Webworld. All rights reserved.
 //
 
 import UIKit
 import CoreLocation
 import SideMenuSwift
 //import ACFloatingTextfield_Swift
 //import Localize_Swift
 
 class LoginViewController: UIViewController, CLLocationManagerDelegate,UITextFieldDelegate {
    
    let manager = CLLocationManager()
    
    var currentLocation = CLLocation()
    @IBOutlet weak var segmentForLanguage: UISegmentedControl!

    var strLatitude = Double()
    var strLongitude = Double()
    
    var strEmailForForgotPassword = String()
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    //textFiled
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblDonTHaveAnyAccount: UILabel!
    //view
    @IBOutlet weak var viewLogin: UIView!
    //    @IBOutlet weak var viewMain: UIView!
    //view
    @IBOutlet weak var btnForgotPassWord: UIButton!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    
    @IBOutlet var lblLaungageName: UILabel!
    @IBOutlet weak var lblSignInTitle: UILabel!
    

    //    @IBOutlet weak var constraintHeightOfLogo: NSLayoutConstraint! // 140
    //    @IBOutlet weak var constraintHeightOfTextFields: NSLayoutConstraint! // 50
    //    @IBOutlet weak var constraintTopOfLogo: NSLayoutConstraint! // 60
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    func setLocalization() {

        txtMobile.placeholder = "Mobile Number".localized
        txtPassword.placeholder = "Password".localized
        btnForgotPassWord.setTitle("Forgot Password?".localized, for: .normal)
        btnSignIn.setTitle("Sign In".localized, for: .normal)
        lblDonTHaveAnyAccount.text = "Don't have an Account? Sign up!".localized
        lblSignInTitle.text = "SIGN IN".localized

    }

    @IBAction func unwindToVCWithSegue(segue:UIStoryboardSegue) { }


    override func loadView() {
        super.loadView()
        self.webserviceOfAppSetting()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        txtMobile.delegate = self

        
        Utilities.setStatusBarColor(color: UIColor.clear)
        
        if UIDevice.current.name == "Bhavesh iPhone" || UIDevice.current.name == "Excellent Web's iPhone 5s" || UIDevice.current.name == "Rahul's iPhone" || UIDevice.current.name == "EWW’s iPhone 6s" || UIDevice.current.name == "Eww’s iPhone 7" || UIDevice.current.name == "EWW iPhone 7 Plus" || UIDevice.current.name == "iPad red" || UIDevice.current.name == "Excellent’s iPhone One" || UIDevice.current.name == "Excellent’s iPhone Second" {
            
            txtMobile.text = "1166993300"
            txtPassword.text = "12345678"
        }
        
        #if targetEnvironment(simulator)
        txtMobile.text = "1166993300"
        txtPassword.text = "12345678"
        #endif


        if let currentLanguage = UserDefaults.standard.object(forKey: "i18n_language") as? String {
            if(currentLanguage == "fr")
            {
                segmentForLanguage.selectedSegmentIndex = 1
            }
        }

        checkPass()
        
        strLatitude = 0
        strLongitude = 0
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if manager.location != nil
                {
                    currentLocation = manager.location!
                    
                    strLatitude = currentLocation.coordinate.latitude
                    strLongitude = currentLocation.coordinate.longitude
                }
                
                manager.startUpdatingLocation()
            }
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func valueChangedForLanguage(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0)
        {
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.standard.set("fr", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }

        setLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.setLocalization()
        //        self.title = "Ingia"
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        //        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height - 50
        //        btnSignUp.clipsToBounds = true
        //
        //        btnSignIn.layer.cornerRadius = btnSignIn.frame.size.height - 30
        //        btnSignIn.clipsToBounds = true
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func btnLaungageClicked(_ sender: Any)
    {
        
        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
            //            SelectedLanguage = secondLanguage
            if SelectedLanguage == "en" {
                setLayoutForswahilLanguage()
                
                //                lblLaungageName.text = "EN"
            } else if SelectedLanguage == secondLanguage {
                setLayoutForenglishLanguage()
                //                setLayoutForswahilLanguage()
                //                lblLaungageName.text = secondLanguage // "SW"
            }
        }
        self.setLocalization()
        
    }
    

    @IBAction func btnSignIn(_ sender: UIButton) {
        //        SideMenuController
        
        if (validateAllFields())
        {
            webserviceForLoginDrivers()
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot Password?", message: "Please enter email", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            
            self.strEmailForForgotPassword = (textField?.text)!
            
            if self.strEmailForForgotPassword == "" {
                NotificationCenter.default.post(name: Notification.Name("checkForgotPassword"), object: nil)
            }
            else {
                self.webserviceForgotPassword()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnFaceBook(_ sender: UIButton) {
    }
    
    @IBAction func btnSignUP(_ sender: UIButton) {
        //        performSegue(withIdentifier: "SegueToRegisterVc", sender: self)
    }
    
    @IBAction func btnGoogle(_ sender: UIButton) {
    }
    
    func checkPass() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlertForPasswordWrong), name: Notification.Name("checkForgotPassword"), object: nil)
    }
    
    @objc func showAlertForPasswordWrong() {
        
        UtilityClass.showAlert("App Name", message: "Please enter mobile number", vc: self)
    }
    
    // ------------------------------------------------------------
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
        
    }
    
    // ------------------------------------------------------------
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var dictData = [String:AnyObject]()
    
    func webserviceForLoginDrivers()
    {
        dictData["Username"] = txtMobile.text as AnyObject
        dictData["Password"] = txtPassword.text as AnyObject
        
        if strLatitude == 0 {
            dictData["Lat"] = "23.0012356" as AnyObject
        } else {
            dictData["Lat"] = strLatitude as AnyObject
        }
        
        if strLongitude == 0 {
            dictData["Lng"] = "72.0012341" as AnyObject
        } else {
            dictData["Lng"] = strLongitude as AnyObject
        }
        dictData["Token"] = Singletons.sharedInstance.deviceToken as AnyObject
        dictData["DeviceType"] = "1" as AnyObject
        
        
        webserviceForDriverLogin(dictParams: dictData as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
                {
                    Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "driver") as! NSDictionary)
                    Singletons.sharedInstance.isDriverLoggedIN = true
                    Utilities.encodeDatafromDictionary(KEY: driverProfileKeys.kKeyDriverProfile, Param: Singletons.sharedInstance.dictDriverProfile)
                    //                                        UserDefaults.standard.set(Singletons.sharedInstance.dictDriverProfile, forKey: driverProfileKeys.kKeyDriverProfile)
                    UserDefaults.standard.set(true, forKey: driverProfileKeys.kKeyIsDriverLoggedIN)
                    
                    Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId") as! String
                    
                    Singletons.sharedInstance.driverDuty = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "DriverDuty") as! String)
                    //                    Singletons.sharedInstance.showTickPayRegistrationSceeen =
                    
                    let profileData = Singletons.sharedInstance.dictDriverProfile
                    
                    if let currentBalance = (profileData?.object(forKey: "profile") as! NSDictionary).object(forKey: "Balance") as? Double
                    {
                        Singletons.sharedInstance.strCurrentBalance = currentBalance
                    }

                    (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                    //                    let next = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
                    //                    self.navigationController?.pushViewController(next, animated: true)
                }
                
            }
            else
            {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert("App Name", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    if let errorMessage = resDict[ GetResponseMessageKey()] as? String
                    {
                        UtilityClass.showAlert("App Name", message: errorMessage, vc: self)

                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("App Name", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
                
            }
        }
    }
    
    // ------------------------------------------------------------
    
    func webserviceForgotPassword()
    {
        var params = [String:AnyObject]()
        params[RegistrationFinalKeys.kEmail] = strEmailForForgotPassword as AnyObject
        
        webserviceForForgotPassword(params as AnyObject) { (result, status) in
            
            if (status) {
                
                print(result)
                let alert = UIAlertController(title: "App Name", message: result.object(forKey: GetResponseMessageKey()) as? String, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print(result)
                
                if let res = result as? String {
                    UtilityClass.showAlert("App Name", message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("App Name", message: resDict.object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("App Name", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
            }
        }
    }
    // ----------------------------------------------------------------------
    
    func webserviceOfAppSetting() {
        //        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)
        
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        var param = String()
        
        param = version + "/" + "IOSDriver"
        
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if(status) {
                print(result)
                /*
                 {
                 "status": true,
                 "update": false,
                 "message": "Ticktoc app new version available"
                 }
                 */
                //                self.viewMain.isHidden = true
                
                if ((result as! NSDictionary).object(forKey: "update") as? Bool) != nil {
                    
                    let alert = UIAlertController(title: "App Name", message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "Update", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.openURL(NSURL(string: appName.kAPPUrl)! as URL)
                    })
                    let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                        
                        if(Singletons.sharedInstance.isDriverLoggedIN)
                        {
                            //                            let next = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
                            //                            self.navigationController?.pushViewController(next, animated: true)
                            (UIApplication.shared.delegate as! AppDelegate).GoToHome()

                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {

                    if(Singletons.sharedInstance.isDriverLoggedIN)
                    {
                        //                        let next = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
                        //                        self.navigationController?.pushViewController(next, animated: false)

                        (UIApplication.shared.delegate as! AppDelegate).GoToHome()

                    }
                    //                    if(Singletons.sharedInstance.isDriverLoggedIN)
                    //                    {
                    //                        let next = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
                    //                        self.navigationController?.pushViewController(next, animated: true)
                    //                    }
                    
                }
                
                //                if(Singletons.sharedInstance.isUserLoggedIN)
                //                {
                //                    self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                //                }//bhaveshbhai
                
                
            }
            else {
                print(result)
                /*
                 {
                 "status": false,
                 "update": false,
                 "maintenance": true,
                 "message": "Server under maintenance, please try again after some time"
                 }
                 */
                
                if let res = result as? String {
                    UtilityClass.showAlert("App Name", message: res, vc: self)
                }
                else if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {
                        //                        UtilityClass.showAlert(appName.kAPPName, message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self)
                        
                        UtilityClass.showAlertWithCompletion("App Name", message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.open((NSURL(string: appName.kAPPUrl)! as URL), options: [:], completionHandler: { (status) in
                                
                            })//openURL(NSURL(string: appName.kAPPUrl)! as URL)
                        })
                    }
                    else {
                        UtilityClass.showAlert("App Name", message: (result as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                    }
                    
                }
                /*
                 {
                 "status": false,
                 "update": true,
                 "message": "Ticktoc app new version available, please upgrade your application"
                 }
                 */
                //                if let res = result as? String {
                //                    UtilityClass.showAlert(appName.kAPPName, message: res, vc: self)
                //                }
                //                else if let resDict = result as? NSDictionary {
                //                    UtilityClass.showAlert(appName.kAPPName, message: resDict.object(forKey: "message") as! String, vc: self)
                //                }
                //                else if let resAry = result as? NSArray {
                //                    UtilityClass.showAlert(appName.kAPPName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                //                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobile {
            let resultText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            if resultText!.count >= 11 {
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    //-------------------------------------------------------------
    // MARK: - Validation Methods
    //-------------------------------------------------------------
    
    func validateAllFields() -> Bool
    {
        //        let isEmailAddressValid = isValidEmailAddress(emailID: txtEmailAddress.text!)
        //        let providePassword = txtPassword.text
        
        //        let isPasswordValid = isPwdLenth(password: providePassword!)
        
        
        if txtMobile.text!.count == 0
        {
            UtilityClass.showAlert("App Name", message: "Please enter mobile number", vc: self)
            return false
        }
            //        else if txtMobile.text!.count != 10 {
            //            UtilityClass.showAlert("App Name", message: "Please enter valid phone number.", vc: self)
            //            return false
            //        }
        else if txtPassword.text!.count == 0
        {
            
            UtilityClass.showAlert("App Name", message: "Please enter password", vc: self)
            
            return false
        }
        //        else if txtPassword.text!.count <= 5 {
        //            UtilityClass.showAlert(appName.kAPPName, message: "Password should be more than 5 characters", vc: self)
        //            return false
        //        }
        
        
        return true
    }
    
    func isValidEmailAddress(emailID: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z)-9.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailID as NSString
            let results = regex.matches(in: emailID, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        }
        catch _ as NSError
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    
 }
