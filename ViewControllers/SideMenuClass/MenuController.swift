//
//  MenuController.swift
//  TiCKTOC-Driver
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import SideMenuController
import SDWebImage
import SideMenuSwift


let KEnglish : String = "EN"
let KSwiley : String = secondLanguage //"SW"
class  MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var aryItemNames = [String]()
    var aryItemIcons = [String]()
    
    var driverFullName = String()
    var driverImage = UIImage()
    var driverEmail = String()
    var strImagPath = String()
    var strSelectedLaungage = String()
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        strSelectedLaungage = KEnglish
        //kMyJobs
        //kiconMyJobs
        //kMyRating
        //kiconMyRating
//        kiconTripToDestination
//        kTripToDestination
        aryItemNames = [kSettings,"Your Running Trip",kPaymentOption,kPassword,kBidList,kInviteFriend,kLogout]
        
        aryItemIcons = [kiconSettings,"iconMyBooking",kiconPaymentOption,kiconPassword,kIconBids,kiconInviteFriend,kIconLogout]

        
        self.view.backgroundColor = UIColor.black
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(MenuController.setRating), name: NSNotification.Name(rawValue: "rating"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        giveGradientColor()
        getDataFromSingleton()
    }
    
    func giveGradientColor() {
        
//        let colorTop =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor//(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
//        let colorMiddle =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor//UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
//        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor//UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        //
        //        let gradientLayer = CAGradientLayer()
        //        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        //        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        //        gradientLayer.frame = self.view.bounds
        //        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    @objc func setRating() {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Mark: tableview method
    
    @IBOutlet var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if aryItemNames.count == 0 {
                return 0
            }
            return 1
        }
        else if section == 1 {
            return aryItemNames.count
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let cellProfile = tableView.dequeueReusableCell(withIdentifier: "MainHeaderTableViewCell") as! MainHeaderTableViewCell
        let cellItemList = tableView.dequeueReusableCell(withIdentifier: "SideMenuItemsList") as! SideMenuTableViewCell
        
        cellProfile.selectionStyle = .none
        cellItemList.selectionStyle = .none
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        
        if indexPath.section == 0 {
            
            cellProfile.imgProfile.layer.cornerRadius = cellProfile.imgProfile.frame.width / 2
            cellProfile.imgProfile.layer.masksToBounds = true
            cellProfile.imgProfile.layer.borderColor = ThemeYellowColor.cgColor
            cellProfile.imgProfile.layer.borderWidth = 1.0
            cellProfile.lblName.text = driverFullName
            cellProfile.lblMobileNumber.text = driverEmail
            //            cellProfile.lblRating.text = Singletons.sharedInstance.strRating
            cellProfile.imgProfile.sd_setImage(with: URL(string: strImagPath), placeholderImage: UIImage(named: "icon_UserImage"), options:[], completed: nil)
//            cellProfile.imgProfile.sd_setImage(with: URL(string: strImagPath))
//            cellProfile.lblLaungageName.layer.cornerRadius = 5
//            cellProfile.lblLaungageName.backgroundColor = ThemeYellowColor
//            cellProfile.lblLaungageName.layer.borderColor = UIColor.black.cgColor
//            cellProfile.lblLaungageName.layer.borderWidth = 0.5

//            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
//                if SelectedLanguage == "en" {
//                    cellProfile.lblLaungageName.text = secondLanguage.uppercased() // "SW"
            //                } else if SelectedLanguage == secondLanguage { // "sw" {
//                    cellProfile.lblLaungageName.text = "EN"
//                }
//            }
//            cellProfile.lblLaungageName.text = strSelectedLaungage
            
//            cellProfile.btnLaungageChange.addTarget(self, action: #selector(btnLaungageClicked(_:)), for: .touchUpInside)
            //            .layer.cornerRadius = btnHome.frame.size.height / 2
            //            btnMyJob.clipsToBounds = true
            //            btnMyJob.borderColor = UIColor.red
            return cellProfile
        }
        else if indexPath.section == 1 {
            cellItemList.lblTtile.text = aryItemNames[indexPath.row].localized
//
            let tintedImage = UIImage.init(named: aryItemIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cellItemList.lblImage.image = tintedImage
            cellItemList.lblImage.tintColor = .white


            return cellItemList
        }
        else {
            return UITableViewCell()
        }
        
    }
    @objc func btnLaungageClicked(_ sender : UIButton)
    {
        
        //        sender.isSelected = !sender.isSelected
        
//        if strSelectedLaungage == KEnglish
//        {
//            strSelectedLaungage = KSwiley
//        }
//        else
//        {
//            strSelectedLaungage = KEnglish
//        }
//
//        self.tableView.reloadData()
        
        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
            if SelectedLanguage == "en" {
                setLayoutForswahilLanguage()
                
            } else if SelectedLanguage == secondLanguage { // "sw" {
                setLayoutForenglishLanguage()
            }
        }
        self.navigationController?.loadViewIfNeeded()
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NotificationChangeLanguage, object: nil)
        
    }
        
    @objc func MyJob(){
        //
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as! MyJobsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
        //     sideMenuController?.performSegue(withIdentifier: "SegueSideMenuToMyJob", sender: self)
    }
    
    
    @objc func PayMentOption(){
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    @objc func Wallet(){
        //        if(Singletons.sharedInstance.CardsVCHaveAryData.count == 0)
        //        {
        //            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        //            self.navigationController?.pushViewController(viewController, animated: true)
        //            
        //        }
        //        else
        //        {
        //            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
        //            self.navigationController?.pushViewController(viewController, animated: true)
        //            
        //        }
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc func MyRating(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyRatingViewController") as! MyRatingViewController
        let homeVC = self.parent?.children.first?.children.first as? HomeViewController
        sideMenuController?.hideMenu(animated: true, completion: nil)
        homeVC?.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func BidList(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BidListContainerViewController") as! BidListContainerViewController
        let homeVC = self.parent?.children.first?.children.first as? HomeViewController
        sideMenuController?.hideMenu(animated: true, completion: nil)
        homeVC?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func InviteFriend(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
        let homeVC = self.parent?.children.first?.children.first as? HomeViewController
        sideMenuController?.hideMenu(animated: true, completion: nil)
        homeVC?.navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func setting(){
        
        let storyboard = UIStoryboard(name: "TripToDestination", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TripToDestinationViewController") as! TripToDestinationViewController

        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc func Legal(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LegalViewController") as! LegalViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc func  Support(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        viewController.headerName = "Support".localized
//        viewController.headerName = "\("App Name".localized) - Terms & Conditions"
        viewController.strURL = WebSupport.SupportURL
//        "https://www.tantaxitanzania.com/front/termsconditions"
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    @objc func LogOut(){
        
//        self.webserviceOFSignOut()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    { 
        if indexPath.section == 1
        {
            let homeVC = self.parent?.children.first?.children.first?.children.first as? HomeViewController
            let strCellItemTitle = aryItemNames[indexPath.row]
            if strCellItemTitle == kPaymentOption
            {

                if(Singletons.sharedInstance.CardsVCHaveAryData.count == 0)
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                    homeVC?.navigationController?.pushViewController(viewController, animated: true)

                }
                else
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
                    homeVC?.navigationController?.pushViewController(viewController, animated: true)
                }

            }
            else if strCellItemTitle == "Your Running Trip" {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MultipleBookingTrackingViewController") as! MultipleBookingTrackingViewController
                homeVC?.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kPassword
            {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                homeVC?.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kBidList
            {
                let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "BidListContainerViewController") as! BidListContainerViewController
                homeVC?.navigationController?.pushViewController(ViewController, animated: true)
            }
            else if strCellItemTitle == kInviteFriend
            {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
                homeVC?.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kSettings
            {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditDriverProfileVC") as! EditDriverProfileVC
                homeVC?.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kTripToDestination
            {
                let storyboard = UIStoryboard(name: "TripToDestination", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "TripToDestinationViewController") as! TripToDestinationViewController
                homeVC?.navigationController?.pushViewController(viewController, animated: true)
            }
            else if strCellItemTitle == kLogout
            {

                RMUniversalAlert.show(in: self, withTitle:appName.kAPPName, message: "Are you sure you want to logout?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Logout".localized, "Cancel".localized], tap: {(alert, buttonIndex) in
                    if (buttonIndex == 2)
                    {
                          (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
                    }
                })


            }

            sideMenuController?.hideMenu()
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
        else if indexPath.section == 1 {
            return 50
        }
        else {
            return 524
        }
    }
    
   
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    @objc func updateProfile()
    {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditDriverProfileVC") as! EditDriverProfileVC
        self.navigationController?.pushViewController(viewController, animated: true)
        //        self.sideMenuController?.embed(centerViewController: viewController)
    }
    func getDataFromSingleton()
    {
        let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as! NSDictionary))
        //         {
        
        
        //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        
        driverFullName = profile.object(forKey: "Fullname") as! String
        driverEmail = profile.object(forKey: "Email") as! String
        
        strImagPath = profile.object(forKey: "Image") as! String
        
        
        //        }
        //        if let profile =  NSMutableDictionary(dictionary: (Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile") as) {
        //
        //
        //            //            NSMutableDictionary(Singletons.sharedInstance.dictDriverProfile.object(forKey: "profile") as NSDictionary).object(forKey: "profile")
        //
        //            driverFullName = profile.object(forKey: "Fullname") as! String
        //            driverMobileNo = profile.object(forKey: "MobileNo") as! String
        //
        //            strImagPath = profile.object(forKey: "Image") as! String
        //        }
        
        
        
        
        tableView.reloadData()
        
    }
    
    // ------------------------------------------------------------
    
    func moveToComingSoon() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ComingSoonVC") as! ComingSoonVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    

    
    
    
}
