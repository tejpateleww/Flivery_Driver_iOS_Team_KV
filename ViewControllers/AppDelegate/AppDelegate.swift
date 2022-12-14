
//  AppDelegate.swift
//  TenTaxi-Driver
//  Created by Excellent Webworld on 09/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.


import UIKit
import SideMenuSwift
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import Fabric
import Crashlytics
import UserNotifications
import FirebaseMessaging
import SocketIO
import Firebase


let googlApiKey = "AIzaSyD1bcITZ_nUkP-ke6xgaP5RIC--tXQU3I4" //"AIzaSyBpHWct2Dal71hBjPis6R1CU0OHZNfMgCw"         // AIzaSyB08IH_NbumyQIAUCxbpgPCuZtFzIT5WQo
let googlPlacesApiKey = "AIzaSyD1bcITZ_nUkP-ke6xgaP5RIC--tXQU3I4" // "AIzaSyCKEP5WGD7n5QWtCopu0QXOzM9Qec4vAfE"   //   AIzaSyBBQGfB0ca6oApMpqqemhx8-UV-gFls_Zk

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate,MessagingDelegate
{
    
    var window: UIWindow?
    let manager = CLLocationManager()
    var bgTask : UIBackgroundTaskIdentifier!
    
    var WaitingTime  = ""
    var WaitingTimeCount  : Double = 0
    var DistanceKiloMeter  = ""
    var Speed  = ""
    var objMessage = MessageObject()
    
    var RoadPickupTimer = Timer()
//    let socket_Manager = SocketIOClient(socketURL: URL(string: socketApiKeys.kSocketBaseURL)!, config: [.log(false), .compress])
    
    
    let socket_Manager = SocketManager(socketURL: URL(string: socketApiKeys.kSocketBaseURL)!, config: [.log(false), .compress])
    lazy var socket = socket_Manager.defaultSocket
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        sleep(2)
        IQKeyboardManager.shared.enable = true
        UserDefaults.standard.set(false, forKey: kIsSocketEmited)
        UserDefaults.standard.synchronize()
        
        if UserDefaults.standard.value(forKey: "i18n_language") == nil {
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }
        
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
        //        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menu")
        //        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        //        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! * 0.85
        //        SideMenuController.preferences.drawing.centerPanelShadow = true
        //        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
        
        SideMenuController.preferences.basic.menuWidth = SCREEN_WIDTH - 40
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.direction = .left
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        
        // Google Map
        
        GMSPlacesClient.provideAPIKey(kGooglePlaceClientAPIKey)
        GMSServices.provideAPIKey(kGoogleServiceAPIKey)
        
        // AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo
        
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.requestAlwaysAuthorization()
        
        if (UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) != nil)
        {
            self.setDataInSingletons()
        }
        else
        {
            Singletons.sharedInstance.isDriverLoggedIN = false
        }
        
        if UserDefaults.standard.object(forKey: "Passcode") as? String == nil {
            Singletons.sharedInstance.setPasscode = ""
        }
        else {
            Singletons.sharedInstance.setPasscode = UserDefaults.standard.object(forKey: "Passcode") as! String
        }
        
        
        // Push Notification Code
        registerForPushNotification()
        
        
        /*
         let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
         
         if remoteNotif != nil
         {
         let key = (remoteNotif as! NSDictionary).object(forKey: "gcm.notification.type")!
         NSLog("\n Custom: \(String(describing: key))")
         self.pushAfterReceiveNotification(typeKey: key as! String, applicationObject: application)
         }
         else {
         //            let aps = remoteNotif!["aps" as NSString] as? [String:AnyObject]
         NSLog("//////////////////////////Normal launch")
         //            self.pushAfterReceiveNotification(typeKey: "")
         
         }
         */
        
        
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }
    
    func setDataInSingletons()
    {
        //        Singletons.sharedInstance.dictDriverProfile = NSMutableDictionary(dictionary:UserDefaults.standard.object(forKey:  driverProfileKeys.kKeyDriverProfile) as! NSDictionary)
        
        let DEcode = Utilities.decodeDictionaryfromData(KEY: driverProfileKeys.kKeyDriverProfile)
        if DEcode != nil || DEcode.count != 0
        {
            Singletons.sharedInstance.dictDriverProfile = DEcode as! NSMutableDictionary
            Singletons.sharedInstance.strDriverID = ((Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary).object(forKey: "Vehicle") as! NSDictionary).object(forKey: "DriverId") as! String
            Singletons.sharedInstance.isDriverLoggedIN = UserDefaults.standard.object(forKey: driverProfileKeys.kKeyIsDriverLoggedIN) as! Bool
            
            if UserDefaults.standard.object(forKey: "DriverDuty") as? String == nil {
                
                Singletons.sharedInstance.driverDuty = "0"
            }
            else {
                Singletons.sharedInstance.driverDuty = UserDefaults.standard.object(forKey: "DriverDuty") as! String
            }
            
            
            if let passOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
                
                if passOn == false {
                    Singletons.sharedInstance.isPasscodeON = false
                }
                else {
                    Singletons.sharedInstance.isPasscodeON = true
                }
            }
            else
            {
                
                Singletons.sharedInstance.isPasscodeON = false
                UserDefaults.standard.set(Singletons.sharedInstance.isPasscodeON, forKey: "isPasscodeON")
                
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        
        //        defaultLocation = location
        
        Singletons.sharedInstance.latitude = location.coordinate.latitude
        Singletons.sharedInstance.longitude = location.coordinate.longitude
        
        if locations.first != nil {
            //            print("location:: (location)")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("App is in Background mode")
        socket.connect()
        socket.on(clientEvent: .connect) {data, ack in
            print ("socket connected")
            
        }
        //        //  Converted to Swift 4 by Swiftify v4.1.6600 - https://objectivec2swift.com/
        //        bgTask = application.beginBackgroundTask(withName: "MyTask", expirationHandler: {() -> Void in
        //            // Clean up any unfinished task business by marking where you
        //            // stopped or ending the task outright.
        //
        //            application.endBackgroundTask(self.bgTask)
        //            self.bgTask = UIBackgroundTaskInvalid
        //        })
        //        // Start the long-running task and return immediately.
        //        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
        //            // Do the work associated with the task, preferably in chunks.
        //            application.endBackgroundTask(self.bgTask)
        //            self.bgTask = UIBackgroundTaskInvalid
        //        })
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let isSwitchOn = UserDefaults.standard.object(forKey: "isPasscodeON") as? Bool {
            Singletons.sharedInstance.isPasscodeON = isSwitchOn
        }
        let passCode = Singletons.sharedInstance.setPasscode
        
        if (passCode != "" && Singletons.sharedInstance.isPasscodeON) {
            
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad = mainStoryboard.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
            initialViewControlleripad.isFromAppDelegate = true
            self.window?.rootViewController?.present(initialViewControlleripad, animated: true, completion: nil)
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //        SocketManager.disconnect()
    }
    
    
    // Push Notification Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        _ = deviceToken.map({ (data)-> String in
            return String(format: "%0.2.2hhx", data)
        })
        //        let token = toketParts.joined()
        Messaging.messaging().apnsToken = deviceToken as Data
        
        if let fcmToken = Messaging.messaging().fcmToken
        {
            Singletons.sharedInstance.deviceToken = fcmToken
        }
        UserDefaults.standard.set(Singletons.sharedInstance.deviceToken, forKey: "Token")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push Notification present method call : \(notification)")
        let userInfo = notification.request.content.userInfo
        print(Appdelegate.window?.rootViewController?.navigationController?.children.first as Any)
        print(userInfo)
       
        if userInfo["gcm.notification.type"] as! String == "chatbid"{
            let BidId = userInfo["gcm.notification.b_id"] as! String
            
            let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController as? SideMenuController
            if vc != nil {
                if let vc : BidChatViewController = (vc?.children.first as? UINavigationController)?.topViewController as? BidChatViewController {
                    if vc.strBidId != BidId {

                        completionHandler([.alert, .sound])
                    }
                    else if vc.strBidId == BidId{
                        print(vc.strBidId)
                        if let response = userInfo["gcm.notification.data"] as? String {
                            let jsonData = response.data(using: .utf8)!
                            let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)

                            if let MsgDataDictionary = dictionary  as? [String: Any]{
                                print(MsgDataDictionary)

                                if MsgDataDictionary["Sender"] as! String == "Driver" {
                                    objMessage.isSender = true
                                }
                                else {
                                    objMessage.isSender = false
                                }
                                
                                objMessage.sender = MsgDataDictionary["Sender"] as? String ?? ""
                                objMessage.senderId = String(MsgDataDictionary["SenderId"] as? Int ?? 0)
                                objMessage.receiverId = MsgDataDictionary["ReceiverId"] as? String ?? ""
                                objMessage.receiver =  MsgDataDictionary["Receiver"] as? String ?? ""
                                objMessage.id = MsgDataDictionary["BidId"] as? String ?? ""
                                objMessage.date = MsgDataDictionary["Date"] as? String ?? ""
                                objMessage.strMessage = MsgDataDictionary["Message"] as? String ?? ""
                                print(objMessage)
                                vc.arrData.append(objMessage)
                                let indexPath = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                vc.tblVw.insertRows(at: [indexPath], with: .bottom)
                                let path = IndexPath.init(row: vc.arrData.count-1, section: 0)
                                vc.tblVw.scrollToRow(at: path, at: .bottom, animated: true)
                            }
                        }
                    }
                }
                else{
                    
                    completionHandler([.alert, .badge, .sound])
                }
                
            }
            else{
                completionHandler([.alert, .badge, .sound])
            }
        } else if userInfo["gcm.notification.type"] as! String == "Logout"{
            let navigationController = UIApplication.shared.windows[0].rootViewController as! UINavigationController
            let viewControllers: [UIViewController] = navigationController.viewControllers
            for aViewController in viewControllers {
                if aViewController is SideMenuController {
                    
                    //                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    let homeVC = aViewController.children[0].children[0].children[0] as? HomeViewController
                    homeVC?.webserviceOFSignOut()
                    //                        }))
                    //                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        let key = (userInfo as NSDictionary).object(forKey: "gcm.notification.type")!
        
        if(application.applicationState == .background || application.applicationState == .inactive)
        {
            self.pushAfterReceiveNotification(typeKey: key as! String, applicationObject: application,  UserObject: userInfo as! [String : Any])
        }
        else
        {
            let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
            
            let alert = UIAlertController(title: "App Name".localized,
                                          message: data["title"] as? String,
                                          preferredStyle: UIAlertController.Style.alert)
            
            //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
            if((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "AcceptBookingRequestNotification")
            {
                alert.addAction(UIAlertAction(title: "Get Details", style: .default, handler: { (action) in
                    self.pushAfterReceiveNotification(typeKey: key as! String, applicationObject: application, UserObject: userInfo as! [String : Any])
                }))
                
                alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .destructive, handler: { (action) in
                    
                }))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            
            else if ((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "Logout")
            {
                let navigationController = application.windows[0].rootViewController as! UINavigationController
                let viewControllers: [UIViewController] = navigationController.viewControllers
                for aViewController in viewControllers {
                    if aViewController is SideMenuController {
                        
                        //                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let homeVC = aViewController.children[0].children[0] as? HomeViewController
                        homeVC?.webserviceOFSignOut()
                        //                        }))
                        //                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else if((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "BookLaterTripNotify")
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    
                    
                    if let NavController = self.window?.rootViewController as? UINavigationController {
                        if let SideMenu = NavController.children.first as? SideMenuController {
                            if let SubNavController = SideMenu.contentViewController as? UINavigationController  {
                                print(SubNavController.children)
                                SubNavController.popToRootViewController(animated: false)
                                if let HomeContainer = SubNavController.children.first as? ContainerViewController {
                                    HomeContainer.scrollToPage(page: 1, animated: true)
                                    
                                    for ChildViewPage in HomeContainer.children {
                                        if let MyJOB = ChildViewPage as? MyJobsViewController {
                                            MyJOB.btnPendingJobsClicked("" as Any)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //                let navController = self.window?.rootViewController as? UINavigationController
                    //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC")
                    //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    //
                    
                    //                    let tabbarvc = (((((((self.window?.rootViewController as! UINavigationController).viewControllers[1].childViewControllers.last!) as! MenuController).navigationController)?.childViewControllers.last) as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                    //                    Singletons.sharedInstance.isFromNotification = true
                    //
                    //                    tabbarvc.selectedIndex = 1
                    //
                    //                let tabBarTemp = (((self.window?.rootViewController as! UINavigationController).childViewControllers.last as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                    //                 Singletons.sharedInstance.isFromNotification = true
                    //                tabBarTemp.selectedIndex = 1
                    //
                    ////                }
                    //            }
                }
                
            }
        }
        //        let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
        //  UtilityClass.showAlert(data["title"] as! String, message: data["body"] as! String, vc: (self.window?.rootViewController)!)
        print(userInfo)
    }
    
    func gettopMostViewController() -> UIViewController?
    {
        return UtilityClass.findtopViewController()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("didReceive; \(response)")
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]   {
            Messaging.messaging().appDidReceiveMessage(userInfo)
            let key = userInfo["gcm.notification.type"]
            
            if(UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive)
            {
                self.pushAfterReceiveNotification(typeKey: key as? String ?? "", applicationObject: UIApplication.shared, UserObject: userInfo)
            }
            else if key as! String  == "chatbid" {
                let BidId = userInfo["gcm.notification.b_id"] as! String
                
                let vc = (self.window?.rootViewController as? UINavigationController)?.topViewController as? SideMenuController
                if vc != nil {
                    if let vc : BidChatViewController = (vc?.children.first as? UINavigationController)?.topViewController as? BidChatViewController {
                       if let response = userInfo["gcm.notification.data"] as? String {
                            let jsonData = response.data(using: .utf8)!
                            let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                            var PassengerId = ""
                            if let MsgDataDictionary = dictionary  as? [String: Any]{
                                print(MsgDataDictionary)
                                
                                if let strSenderId = MsgDataDictionary["SenderId"] as? String {
                                    PassengerId = strSenderId
                                } else if let StrSenderId = MsgDataDictionary["SenderId"] as? Int {
                                    PassengerId = "\(StrSenderId)"
                                }
                                
                            }
                            vc.strPassengerId = PassengerId
                            vc.strBidId = BidId
                            vc.webserviceForChatHistory()
                        }
                   }
                    else{
                        if let vwController = ((self.gettopMostViewController()?.children.first as? UINavigationController)?.viewControllers.last) {
                            if let vcChat = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController {
                                
                                guard  let BidId = userInfo["gcm.notification.b_id"] as? String else {
                                    return
                                }
                                if let response = userInfo["gcm.notification.data"] as? String {
                                    let jsonData = response.data(using: .utf8)!
                                    let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
                                     var PassengerId = ""
                                    if let MsgDataDictionary = dictionary  as? [String: Any]{
                                        print(MsgDataDictionary)
                                       
                                        if let strSenderId = MsgDataDictionary["SenderId"] as? String {
                                            PassengerId = strSenderId
                                        } else if let StrSenderId = MsgDataDictionary["SenderId"] as? Int {
                                            PassengerId = "\(StrSenderId)"
                                        }
                                       
                                    }
                                    vcChat.strPassengerId = PassengerId
                                    vcChat.strBidId = BidId
                                    vwController.navigationController?.pushViewController(vcChat, animated: true)
                                }
 
                            }
                        }
                    }
              }
            }
                
            else
            {
                let data = ((userInfo["aps"]! as! [String : AnyObject])["alert"]!) as! [String : AnyObject]
                let alert = UIAlertController(title: "App Name".localized,
                                              message: data["title"] as? String,
                                              preferredStyle: UIAlertController.Style.alert)
                
                //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
                if(userInfo["gcm.notification.type"]! as! String == "AcceptBookingRequestNotification")
                {
                    alert.addAction(UIAlertAction(title: "Get Details", style: .default, handler: { (action) in
                        self.pushAfterReceiveNotification(typeKey: key as? String ?? "", applicationObject: UIApplication.shared,UserObject: userInfo)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .destructive, handler: { (action) in
                        
                    }))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                /*
                 if key as? String == "chatbid" {
                 if !Singletons.sharedInstance.isChatingPresented {
                 let dictData = userInfo["gcm.notification.data"] as! String
                 let data = dictData.data(using: .utf8)!
                 do
                 {
                 if let jsonResponse = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                 {
                 var UserDict = [String:Any]()
                 //                        UserDict["BidId"] = jsonResponse["BidId"] as! String
                 //                        UserDict["SenderId"] = jsonResponse["SenderId"] as! String
                 if let vwController = ((gettopMostViewController()?.childViewControllers.first as? UINavigationController)?.viewControllers.last) {
                 if let vcChat = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController {
                 
                 guard let strBidID = jsonResponse["BidId"] as? String else {
                 return
                 }
                 
                 var PassengerId = ""
                 if let strSenderId = jsonResponse["SenderId"] as? String {
                 PassengerId = strSenderId
                 } else if let StrSenderId = jsonResponse["SenderId"] as? Int {
                 PassengerId = "\(StrSenderId)"
                 }
                 
                 vcChat.strPassengerId = PassengerId
                 vcChat.strBidId = strBidID
                 vwController.navigationController?.pushViewController(vcChat, animated: true)
                 }
                 }
                 
                 }
                 else {
                 print("bad json")
                 }
                 }
                 catch let error as NSError
                 {
                 print(error)
                 }
                 }
                 }
                 else
                 */
                else if (userInfo["gcm.notification.type"]! as! String == "Logout")
                {
                    let navigationController = UIApplication.shared.windows[0].rootViewController as! UINavigationController
                    let viewControllers: [UIViewController] = navigationController.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is SideMenuController {
                            
                            //                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            let homeVC = aViewController.children[0].children[0] as? HomeViewController
                            homeVC?.webserviceOFSignOut()
                            //                        }))
                            //                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                else if((userInfo as! [String:AnyObject])["gcm.notification.type"]! as! String == "BookLaterTripNotify")
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        
                        if let NavController = self.window?.rootViewController as? UINavigationController {
                            if let SideMenu = NavController.children.first as? SideMenuController {
                                if let SubNavController = SideMenu.contentViewController as? UINavigationController  {
                                    print(SubNavController.children)
                                    SubNavController.popToRootViewController(animated: false)
                                    if let HomeContainer = SubNavController.children.first as? ContainerViewController {
                                        HomeContainer.scrollToPage(page: 1, animated: true)
                                        
                                        for ChildViewPage in HomeContainer.children {
                                            if let MyJOB = ChildViewPage as? MyJobsViewController {
                                                MyJOB.btnPendingJobsClicked("" as Any)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        //                let navController = self.window?.rootViewController as? UINavigationController
                        //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC")
                        //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                        //
                        
                        //                    let tabbarvc = (((((((self.window?.rootViewController as! UINavigationController).viewControllers[1].childViewControllers.last!) as! MenuController).navigationController)?.childViewControllers.last) as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                        //                    Singletons.sharedInstance.isFromNotification = true
                        //
                        //                    tabbarvc.selectedIndex = 1
                        //
                        //                let tabBarTemp = (((self.window?.rootViewController as! UINavigationController).childViewControllers.last as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                        //                 Singletons.sharedInstance.isFromNotification = true
                        //                tabBarTemp.selectedIndex = 1
                        //
                        ////                }
                        //            }
                    }
                    
                }
            }
        }
        completionHandler()
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Push Notification Methods
    //-------------------------------------------------------------
    
    func registerForPushNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            
            print("Permissin granted: \(granted)")
            
            self.getNotificationSettings()
        })
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {(settings) in
            
            print("Notification Settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    
    // MARK:- Login & Logout Methods
    
    func GoToHome() {
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let CustomSideMenu = storyborad.instantiateViewController(withIdentifier: "SideMenu") as! SideMenuController
        let NavHomeVC = UINavigationController(rootViewController: CustomSideMenu)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
    }
    
    func GoToLogin() {
        
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let Login = storyborad.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //        let customNavigation = UINavigationController(rootViewController: Login)
        let NavHomeVC = UINavigationController(rootViewController: Login)
        NavHomeVC.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = NavHomeVC
        
    }
    
    func GoToLogout() {
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
            
            if key == "Token" || key  == "i18n_language" {
                
            }
            else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        //        UserDefaults.standard.set(false, forKey: kIsSocketEmited)
        //        UserDefaults.standard.synchronize()
        
        Singletons.sharedInstance.strPassengerID = ""
        UserDefaults.standard.removeObject(forKey: "profileData")
        Singletons.sharedInstance.isDriverLoggedIN = false
        //                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        UserDefaults.standard.removeObject(forKey: "Passcode")
        Singletons.sharedInstance.setPasscode = ""
        
        UserDefaults.standard.removeObject(forKey: "isPasscodeON")
        Singletons.sharedInstance.isPasscodeON = false
        
        Singletons.sharedInstance.isPasscodeON = false
        self.GoToLogin()
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - FireBase Methods
    //-------------------------------------------------------------
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        let token = Messaging.messaging().fcmToken
        Singletons.sharedInstance.deviceToken = token!
        UserDefaults.standard.set(Singletons.sharedInstance.deviceToken, forKey: "Token")
        print("FCM token: \(token ?? "")")
        
    }
    
    func pushAfterReceiveNotification(typeKey : String, applicationObject:UIApplication, UserObject:[String:Any]) {
        if (typeKey == "Logout") {
            let navigationController = applicationObject.windows[0].rootViewController as! UINavigationController
            let viewControllers: [UIViewController] = navigationController.viewControllers
            for aViewController in viewControllers {
                if aViewController is SideMenuController {
                    let homeVC = aViewController.children[0].children[0] as? HomeViewController
                    homeVC?.webserviceOFSignOut()
                }
            }
        } else if(typeKey == "AddMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "TransferMoney")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let navController = self.window?.rootViewController as? UINavigationController
                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "WalletHistoryViewController")
                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                    
                })
            }
        }
        else if(typeKey == "PostBid")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !Singletons.sharedInstance.isBidListOpened {
                    if let vwController = ((self.gettopMostViewController()?.children.first as? UINavigationController)?.viewControllers.last) {
                        if let vcChat = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BidListContainerViewController") as? BidListContainerViewController {
                            vwController.navigationController?.pushViewController(vcChat, animated: true)
                        }
                    }
                }
            }
        }
        else if(typeKey == "AcceptDriver")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if  !Singletons.sharedInstance.isBidListOpened {
                    if let vwController = ((self.gettopMostViewController()?.children.first as? UINavigationController)?.viewControllers.last) {
                        if let vcChat = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BidListContainerViewController") as? BidListContainerViewController {
                            vwController.navigationController?.pushViewController(vcChat, animated: true)
                        }
                    }
                }
            }
        }
            //        else if(typeKey == "Tickpay")
            //        {
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //                let tabbarvc = (((((((self.window?.rootViewController as! UINavigationController).viewControllers[1].childViewControllers.last!) as! MenuController).navigationController)?.childViewControllers.last) as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
            //
            //                tabbarvc.selectedIndex = 4
            //            }
            //        }
        else if(typeKey == "RejectDispatchJobRequest")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                //                let navController = self.window?.rootViewController as? UINavigationController
                //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "PastJobsListVC")
                //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                //
                //                })
                //
                //                let tabBarTemp = (((self.window?.rootViewController as! UINavigationController).childViewControllers.last as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                //
                //                tabBarTemp.selectedIndex = 1
                //                let MyJob = tabBarTemp.childViewControllers[1] as! MyJobsViewController
                //
                //                MyJob.btnPastJobsClicked(MyJob.btnPastJobs)
            }
        }
        else if typeKey == "chatbid" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !Singletons.sharedInstance.isChatingPresented {
                    let dictData = UserObject["gcm.notification.data"] as! String
                    let data = dictData.data(using: .utf8)!
                    do
                    {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
                        {
                            //                        var UserDict = [String:Any]()
                            //                        UserDict["BidId"] = jsonResponse["BidId"] as! String
                            //                        UserDict["SenderId"] = jsonResponse["SenderId"] as! String
                            if let vwController = ((self.gettopMostViewController()?.children.first as? UINavigationController)?.viewControllers.last) {
                                if let vcChat = UIStoryboard.init(name: "ChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "BidChatViewController") as? BidChatViewController {
                                    
                                    guard let strBidID = jsonResponse["BidId"] as? String else {
                                        return
                                    }
                                    var PassengerId = ""
                                    if let strSenderId = jsonResponse["SenderId"] as? String {
                                        PassengerId = strSenderId
                                    } else if let StrSenderId = jsonResponse["SenderId"] as? Int {
                                        PassengerId = "\(StrSenderId)"
                                    }
                                    vcChat.strPassengerId = PassengerId
                                    vcChat.strBidId = strBidID
                                    vwController.navigationController?.pushViewController(vcChat, animated: true)
                                }
                            }
                            
                        }
                        else {
                            print("bad json")
                        }
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
                }
            }
        }
        else if(typeKey == "BookLaterTripNotify")
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                
                if let NavController = self.window?.rootViewController as? UINavigationController {
                    if let SideMenu = NavController.children.first as? SideMenuController {
                        if let SubNavController = SideMenu.contentViewController as? UINavigationController  {
                            print(SubNavController.children)
                            SubNavController.popToRootViewController(animated: false)
                            if let HomeContainer = SubNavController.children.first as? ContainerViewController {
                                HomeContainer.scrollToPage(page: 1, animated: true)
                                
                                for ChildViewPage in HomeContainer.children {
                                    if let MyJOB = ChildViewPage as? MyJobsViewController {
                                        MyJOB.btnPendingJobsClicked("" as Any)
                                    }
                                }
                            }
                        }
                    }
                }
                
                //                let navController = self.window?.rootViewController as? UINavigationController
                //                let notificationController: UIViewController? = navController?.storyboard?.instantiateViewController(withIdentifier: "FutureBookingVC")
                //                navController?.present(notificationController ?? UIViewController(), animated: true, completion: {
                //
                
                //                    let tabbarvc = (((((((self.window?.rootViewController as! UINavigationController).viewControllers[1].childViewControllers.last!) as! MenuController).navigationController)?.childViewControllers.last) as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                //                    Singletons.sharedInstance.isFromNotification = true
                //
                //                    tabbarvc.selectedIndex = 1
                //
                //                let tabBarTemp = (((self.window?.rootViewController as! UINavigationController).childViewControllers.last as! SideMenuController).childViewControllers[0] as! UINavigationController).childViewControllers[0] as! TabbarController
                //                 Singletons.sharedInstance.isFromNotification = true
                //                tabBarTemp.selectedIndex = 1
                //
                ////                }
                //            }
            }
            
        }
        
    }
}

extension String {
    var localized: String {
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}


// ----------------------------------------------------------
// ----------------------------------------------------------

let LCLBaseBundle = "Base"
let secondLanguage = "fr"


extension UILabel {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.text != nil {
            //            count = count + 1
            self.text = self.text?.localized
            //            print("The count is \(count)")
        }
        
    }
}

//public extension String {
/**
 Swift 2 friendly localization syntax, replaces NSLocalizedString
 - Returns: The localized string.
 */
//    func localized1() -> String {
//        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
//            return bundle.localizedString(forKey: self, value: nil, table: nil)
//        }
//        else if let path = Bundle.main.path(forResource: LCLBaseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
//            return bundle.localizedString(forKey: self, value: nil, table: nil)
//        }
//        return self
//    }
//}

func setLayoutForswahilLanguage()
{
    //    UserDefaults.standard.set("sw", forKey: "i18n_language")
    UserDefaults.standard.set(secondLanguage, forKey: "i18n_language")
    UserDefaults.standard.synchronize()
    Localize.setCurrentLanguage(secondLanguage)
}
func setLayoutForenglishLanguage()
{
    UserDefaults.standard.set("en", forKey: "i18n_language")
    UserDefaults.standard.synchronize()
    Localize.setCurrentLanguage("en")
}

// ----------------------------------------------------------
// ----------------------------------------------------------

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Base bundle as fallback.
//let LCLBaseBundle = "Base"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

// MARK: Localization Syntax
/**
 Swift 1.x friendly localization syntax, replaces NSLocalizedString
 - Parameter string: Key to be localized.
 - Returns: The localized string.
 */
public func Localized(_ string: String) -> String {
    return string.localized1()
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
public func Localized(_ string: String, arguments: CVarArg...) -> String {
    return String(format: string.localized1(), arguments: arguments)
}

/**
 Swift 1.x friendly plural localization syntax with a format argument
 
 - parameter string:   String to be formatted
 - parameter argument: Argument to determine pluralisation
 
 - returns: Pluralized localized string.
 */
public func LocalizedPlural(_ string: String, argument: CVarArg) -> String {
    return string.localizedPlural(argument)
}


public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized1() -> String {
        if let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
            print("Path: \(path)")
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        else if let path = Bundle.main.path(forResource: LCLBaseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized1(), arguments: arguments)
    }
    
    /**
     Swift 2 friendly plural localization syntax with a format argument
     
     - parameter argument: Argument to determine pluralisation
     
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized1() as NSString, argument) as String
    }
}



// MARK: Language Setting Functions

open class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    open class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard.object(forKey: "i18n_language") as? String {
            print("currentLanguage: \(currentLanguage)")
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    open class func setCurrentLanguage(_ language: String) {
        
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    open class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    open class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    open class func displayNameForLanguage(_ language: String) -> String {
        let locale : Locale = Locale(identifier: currentLanguage())
        if let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
}




func localizeString(stringToLocalize:String) -> String
{
    // Get the corresponding bundle path.
    let selectedLanguage = Localize.currentLanguage()
    let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
    
    // Get the corresponding localized string.
    let languageBundle = Bundle(path: path!)
    return languageBundle!.localizedString(forKey: stringToLocalize, value: "", table: nil)
}

func localizeUI(parentView:UIView)
{
    for view:UIView in parentView.subviews
    {
        if let potentialButton = view as? UIButton
        {
            if let titleString = potentialButton.titleLabel?.text {
                potentialButton.setTitle(localizeString(stringToLocalize: titleString), for: .normal)
            }
        }
            
        else if let potentialLabel = view as? UILabel
        {
            if potentialLabel.text != nil {
                potentialLabel.text = localizeString(stringToLocalize: potentialLabel.text!)
            }
        }
        
        localizeUI(parentView: view)
    }
}

