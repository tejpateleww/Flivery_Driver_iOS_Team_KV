//
//  PostABidViewController.swift
//  Flivery User
//
//  Created by Mayur iMac on 26/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
import GoogleMaps
import GooglePlaces
import SDWebImage


class PostABidViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var txtShippersName: ACFloatingTextfield?
    @IBOutlet weak var txtPickUpLocation: UITextField?
    @IBOutlet weak var txtDropLocation: UITextField?
    @IBOutlet weak var txtBudget: ACFloatingTextfield?
    @IBOutlet weak var TxtDateAndTime: ACFloatingTextfield?
    @IBOutlet weak var txtWeight: ACFloatingTextfield?
    @IBOutlet weak var txtQuantity: ACFloatingTextfield?
    @IBOutlet weak var txtNotes: ACFloatingTextfield?
    @IBOutlet weak var txtVehicleType: ACFloatingTextfield?
    @IBOutlet weak var txtPayment: ACFloatingTextfield?
    @IBOutlet weak var imgDocument : UIImageView!
    
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnSelectLuggage: UIButton!
 
    var strPassengerID = String()
    var strbidID = String()
    var aryData = [[String:AnyObject]]()
    var selectedIndexPath: IndexPath?
    var strCarModelClass = String()
    var strCarModelID = String()
    var strNavigateCarModel = String()
    var imageView = UIImageView()
    var statusType = String()
    private let refreshControl = UIRefreshControl()
    var BidData = [[String:AnyObject]]()
    @IBOutlet weak var collectionviewCars: UICollectionView!
    @IBOutlet var viewSelectVehicle: UIView!

    @IBOutlet weak var imgPaymentOption: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        txtDropLocation?.delegate = self
        txtPickUpLocation?.delegate = self
        dataSetup()
        self.setNavBarWithMenuORBack(Title: "Bid Details".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        setupButtonAndTextfield()
       webserviceBidAccept()
    }
    
    @IBAction func btnActionAccept(_ sender: UIButton) {
        btnReject.isSelected = false
        btnAccept.isSelected = true
        if validation(){
            webserviceBidAccept()
        }
        
    }
    
    @IBAction func btnActionReject(_ sender: UIButton) {
        btnReject.isSelected = true
        btnAccept.isSelected = false
        if validation(){
            webserviceBidAccept()
        }
    }
    
    func dataSetup(){
        if let modelName = BidData[0]["ShipperName"] as? String{
            txtShippersName!.text = modelName
        }
        if let PickupLocation = BidData[0]["PickupLocation"] as? String{
            txtPickUpLocation!.text = PickupLocation
        }
        if let pickup = BidData[0]["PickupDateTime"] as? String{
            TxtDateAndTime?.text = pickup
//            let pickupDate : [String] = pickup.components(separatedBy: " ")
//            var date : String = pickupDate[0]
//            let dateString = UtilityClass.formattedDateFromString(dateString: date, withFormat:"dd MMMM" )
//            customCell.lblPickupDate.text = dateString
        }
        if let droplocation = BidData[0]["DropoffLocation"] as? String{
            txtDropLocation!.text = droplocation
        }
        if let modelName = BidData[0]["Name"] as? String{
            txtVehicleType!.text = modelName
        }
        if let modelimage = BidData[0]["ModelImage"] as? String{
            imageView.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + modelimage), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        }
        if let Docimage = BidData[0]["Image"] as? String{
            imgDocument.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + Docimage), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        }
        if let cardID = BidData[0]["CardId"] as? String{
           
        }
        if let bidID = BidData[0]["BidId"] as? String{
            strbidID = bidID
        }
        if let passengerID = BidData[0]["PassengerId"] as? String{
            strPassengerID = passengerID
            
        }
    }

    func setupButtonAndTextfield()
    {
        btnAccept.layer.cornerRadius = btnAccept.frame.size.height / 2
        btnAccept.clipsToBounds = true
        btnReject.layer.cornerRadius = btnReject.frame.size.height / 2
        btnReject.clipsToBounds = true
        btnAccept.backgroundColor = UIColor.black
        //imageView = UIImageView(image: UIImage(named: "Title_logo"))
        imageView.frame = CGRect(x: 0, y: 5, width: 50 , height: 30)
        imageView.contentMode = .scaleAspectFit
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        paddingView.addSubview(imageView)
        txtVehicleType?.rightViewMode = .always
        txtVehicleType?.rightView = paddingView

    }
    
    func validation() -> Bool{
        if txtNotes?.text == "" || txtNotes?.text?.trimmingCharacters(in:.whitespaces) == ""{
             UtilityClass.showAlert("", message: "Please Enter Notes", vc: self)
            return false
        }
        else if txtBudget?.text == "" || txtBudget?.text?.trimmingCharacters(in:.whitespaces) == ""{
            UtilityClass.showAlert("", message: "Please Enter Budget", vc: self)
            return false
        }
        return true
        
    }
    
    func webserviceBidAccept(){
        statusType = btnAccept.isSelected == true ? "1" : "0"
         let param = [
            "PassengerId" : strPassengerID,
            "DriverId"    : Singletons.sharedInstance.strDriverID,
            "BidId"       : strbidID,
            "Budget"      : txtBudget?.text! as Any,
            "Notes"       : txtNotes?.text as Any,
            "Status"      : statusType
        
        ] as [String:AnyObject]
        print(param)
        webserviceForBidAccept(param as AnyObject) { (result, status) in
            if status{
                print(result)
                self.aryData = (result as! NSDictionary).object(forKey: "data") as! [[String:AnyObject]]
                Singletons.sharedInstance.BidAcceptData = self.aryData
                self.refreshControl.endRefreshing()
                
            }
            else {
                print(result)
                UtilityClass.defaultMsg(result:result)
                //  UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
            }

        }
    }

}
