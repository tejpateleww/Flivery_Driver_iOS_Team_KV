//
//  TripToDestinationViewController.swift
//   TenTaxi-Driver
//
//  Created by Excellent WebWorld on 05/04/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FormTextField


class TripToDestinationViewController: BaseViewController, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate
{
    @IBOutlet var btnSelectDestination: UIButton!
    @IBOutlet var viewSwitchButton: UIView!
    @IBOutlet var imgSwitchIcon: UIImageView!
    @IBOutlet var txtDestination: UITextField!
    @IBOutlet var viewTextfield: UIView!
    @IBOutlet weak var lblDestinationTrip: UILabel!
     var userDefault = UserDefaults.standard
    @IBOutlet var btnDone: UIButton!
    var doubleLat = Double()
    var doubleLng = Double()
    
    var strSwitchONOFF = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        SingletonsForTripToDestination.sharedInstance.isFirstDestinationSelected = false
        
        if((userDefault.bool(forKey: "buttonSelected")) && (userDefault.bool(forKey: "buttonSelected")) != false)
        {
            Singletons.sharedInstance.dictTripDestinationLocation["trip_to_destin"] = 1  as AnyObject
            Singletons.sharedInstance.dictTripDestinationLocation["location"] = userDefault.object(forKey: "tripDestination") as AnyObject
            
        }
        
        if(Singletons.sharedInstance.dictTripDestinationLocation["trip_to_destin"] as? Int == 1)
        {
            SingletonsForTripToDestination.sharedInstance.isFirstDestinationSelected = true
            self.txtDestination.text = Singletons.sharedInstance.dictTripDestinationLocation["location"] as? String
            btnSelectDestination.isSelected = true
            if(self.btnSelectDestination.isSelected)
            {
                self.txtDestination.isUserInteractionEnabled = false
            }
        }

        if SingletonsForTripToDestination.sharedInstance.isFirstDestinationSelected == true
        {
            imgSwitchIcon.image = UIImage.init(named: "iconSwitchOn")
            viewTextfield.isHidden = false
            btnDone.isHidden = false
        }
        else
        {
            imgSwitchIcon.image = UIImage.init(named: "iconSwitchOff")
            viewTextfield.isHidden = true
            btnDone.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setLocalizable()
        setNavBarWithMenuORBack(Title: "Trip to Destination".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
    }
    
    func  setLocalizable()
    {
//        self.headerView?.lblTitle.text = "Trip to Destination".localized
        self.title = "Trip to Destination".localized
        self.lblDestinationTrip.text = "Trip to Destination".localized
        btnDone.setTitle("Submit".localized, for: .normal)
            txtDestination.placeholder = "Destination Location".localized
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtDestination
        {  self.txtDestinationLocation(txtDestination)
            return false
        }
        return true
    }

    @IBAction func btnFirstDestinationClicked(_ sender: UIButton)
    {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected
        {
            imgSwitchIcon.image = UIImage.init(named: "iconSwitchOn")
            viewTextfield.isHidden = false
            btnDone.isHidden = false
            strSwitchONOFF = "on"
        }
        else
        {
            imgSwitchIcon.image = UIImage.init(named: "iconSwitchOff")
            viewTextfield.isHidden = true
            btnDone.isHidden = true
            strSwitchONOFF = "off"
            self.txtDestination.isUserInteractionEnabled = true
            userDefault.removeObject(forKey: "tripDestination")
            userDefault.removeObject(forKey: "buttonSelected")
            Singletons.sharedInstance.dictTripDestinationLocation["trip_to_destin"] = 0 as AnyObject
            Singletons.sharedInstance.dictTripDestinationLocation["location"] = "" as AnyObject
            let strAddress = txtDestination.text!
            
            if strAddress != ""
            {
                var dictParam = [String:AnyObject]()
                let driverID = Singletons.sharedInstance.strDriverID
                
                dictParam["DriverId"] = driverID as AnyObject
                dictParam["Location"] = "" as AnyObject
                dictParam["Lat"] = "" as AnyObject
                dictParam["Lng"] = "" as AnyObject
                dictParam["Status"] = 0 as AnyObject
        
                
                self.webserviceCallToOnOffTripToDestination(dictParam: dictParam)
            }
            
        }

   }
    
    @IBAction func btnSecondDestinationClicked(_ sender: UIButton)
    {
        if SingletonsForTripToDestination.sharedInstance.isFirstDestinationSelected == false
        {
            UtilityClass.showAlert("", message: "Please select First Destination", vc: self)
        }
        else
        {
            
            SingletonsForTripToDestination.sharedInstance.isSecondDestinationSelected = true
            SingletonsForTripToDestination.sharedInstance.strSecondDestination = "CTM"
            SingletonsForTripToDestination.sharedInstance.isTripDestinationHide = true
             UtilityClass.showAlert("", message: "Your second destination selected.", vc: self)
            UserDefaults.standard.set(SingletonsForTripToDestination.sharedInstance.isTripDestinationHide, forKey: "isTripDestinationShow")

        }
    }
    
    @IBAction func txtDestinationLocation(_ sender: UITextField)
    {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        
        present(acController, animated: true, completion: nil)
        
    }
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txtDestination.text = place.formattedAddress
        doubleLat = place.coordinate.latitude
        doubleLng = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    func webserviceCallToOnOffTripToDestination(dictParam: [String : AnyObject])
    {
        webserviceForManageTripToDestination(dictParam as AnyObject) { (result, status) in
            if (status)
            {
                print(result)
                if ((result as! [String:AnyObject])["status"] as! Int == 1)
                {
                    UtilityClass.showAlertWithCompletion("App Name".localized, message: (result as! [String:AnyObject])[GetResponseMessageKey()] as! String, vc: self, completionHandler: { (Status) in
                        self.userDefault.set(self.btnSelectDestination.isSelected, forKey: "buttonSelected")
                        self.userDefault.set(self.txtDestination.text, forKey: "tripDestination")
                        if(self.btnSelectDestination.isSelected)
                        {
                            self.txtDestination.isUserInteractionEnabled = false
                        }
                    })
                }
            }
            else
            {
                if let res = result as? String {
                    UtilityClass.showAlert("App Name".localized, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("App Name".localized, message: resDict.object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("App Name".localized, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
            }
//            else
//            {
//                print(result)
//            }
        }
    }
    
    @IBAction func btnDoneClicked(_ sender: UIButton)
    {

        let strAddress = txtDestination.text!
        if strAddress == "" {
            UtilityClass.showAlert("App Name".localized, message: "Please enter a Destination.".localized, vc: self)
        } else {
            var dictParam = [String:AnyObject]()
            let driverID = Singletons.sharedInstance.strDriverID
            
            dictParam["DriverId"] = driverID as AnyObject
            dictParam["Location"] = strAddress as AnyObject
            dictParam["Lat"] = doubleLat as AnyObject
            dictParam["Lng"] = doubleLng as AnyObject
            
            if strSwitchONOFF == "on"
            {
                dictParam["Status"] = 1 as AnyObject
            }
            else
            {
                dictParam["Status"] = 0 as AnyObject
            }
            self.webserviceCallToOnOffTripToDestination(dictParam: dictParam)
        }
    }
    
    
    
}
