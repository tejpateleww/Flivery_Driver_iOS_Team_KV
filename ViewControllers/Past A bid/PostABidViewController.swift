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

    //MARK:- ====== Outlets ============
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
 
     //MARK:- ====== Variables ============
    var strPassengerID = String()
    var strbidID = String()
    var aryData = [String:AnyObject]()
    var selectedIndexPath: IndexPath?
    var strCarModelClass = String()
    var strCarModelID = String()
    var strNavigateCarModel = String()
    var imageView = UIImageView()
    var statusType = String()
    var budget = String()
    private let refreshControl = UIRefreshControl()
    var BidData = [[String:AnyObject]]()
    @IBOutlet weak var collectionviewCars: UICollectionView!
    @IBOutlet var viewSelectVehicle: UIView!
    @IBOutlet weak var imgPaymentOption: UIImageView!
    
     //MARK:- ====== View Controller Life cycle ============
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtDropLocation?.delegate = self
        txtPickUpLocation?.delegate = self
        dataSetup()
        self.setNavBarWithMenuORBack(Title: "Bid Details".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        setupButtonAndTextfield()
      
    }
     //MARK:- ======= Data Setup =======
    @IBAction func btnActionAccept(_ sender: UIButton) {
        btnReject.isSelected = false
        btnAccept.isSelected = true
        if txtBudget?.text == "" || txtBudget?.text?.trimmingCharacters(in:.whitespaces) == ""{
            UtilityClass.showAlert("", message: "Please Enter Budget", vc: self)
        }
        else{

            var strBudget = Int()

            if let budget = BidData[0]["Budget"] as? String{
                strBudget = Int(budget)!
            }
            else if let budget = BidData[0]["Budget"] as? Int{
                strBudget = budget
            }


            var enteredBudget = Int()

            if let budget = txtBudget?.text{
                enteredBudget = Int(budget)!
            }


            if(enteredBudget > strBudget)
            {
                UtilityClass.showAlert("", message: "The entered budget should be less than the given budget", vc: self)
            }
            else
            {

                webserviceBidAccept()
            }
        }
    }
    
     //MARK:- ======= Accept Button Action=======
    @IBAction func btnActionReject(_ sender: UIButton) {
        btnReject.isSelected = true
        btnAccept.isSelected = false
        webserviceBidAccept()
    }
     //MARK:- ======= Data Setup =======
    func dataSetup(){
        if let modelName = BidData[0]["ShipperName"] as? String{
            txtShippersName!.text = modelName
        }
        if let PickupLocation = BidData[0]["PickupLocation"] as? String{
            txtPickUpLocation!.text = PickupLocation
        }
        if let pickup = BidData[0]["PickupDateTime"] as? String{
            
            let pickupDate : [String] = pickup.components(separatedBy: " ")
            var date : String = pickupDate[0]
            var pickupTime:String = pickupDate[1]
            print(pickupTime)
            let dateformat = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
             pickupTime = formatter.string(from: dateformat) //"10:22 AM"
            
            let dateString = UtilityClass.formattedDateFromString(dateString: date, withFormat:"dd-MM-yyyy" )
            TxtDateAndTime?.text = dateString! + " - " + pickupTime
           
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
        if let Budget = BidData[0]["Budget"] as? String{
             budget = Budget
        }
        if let bidID = BidData[0]["Id"] as? String{
            strbidID = bidID
            print(bidID)
        }
        if let passengerID = BidData[0]["PassengerId"] as? String{
            strPassengerID = passengerID
            print(passengerID)
        }

        if let budget = BidData[0]["Budget"] as? String{
            txtBudget?.placeholder = "Max.$\(budget)"
        }
        else if let budget = BidData[0]["Budget"] as? Int{
            txtBudget?.placeholder = "Max.$\(budget)"
        }
    }
    
 //MARK:- ======= View Setup =======
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
        txtVehicleType?.isUserInteractionEnabled = false
        txtShippersName?.isUserInteractionEnabled = false
        TxtDateAndTime?.isUserInteractionEnabled = false
        txtPickUpLocation?.isUserInteractionEnabled = false
        txtDropLocation?.isUserInteractionEnabled = false

    }
     //MARK:- ======= Validation =======
    func validation() -> Bool{
        if txtBudget?.text == "" || txtBudget?.text?.trimmingCharacters(in:.whitespaces) == ""{
            UtilityClass.showAlert("", message: "Please Enter Budget", vc: self)
            return false
        }
         else if txtNotes?.text == "" || txtNotes?.text?.trimmingCharacters(in:.whitespaces) == ""{
            UtilityClass.showAlert("", message: "Please Enter Notes", vc: self)
            return false
        }
        return true
    }
    //MARK:- ======= Api Call For BidAccept =======
    func webserviceBidAccept(){
        statusType = btnAccept.isSelected == true ? "1" : "0"
         let strBudget = btnAccept.isSelected == true ? txtBudget?.text : budget
         let notes = txtNotes?.text != "" ? txtNotes?.text : ""
         let param = [
            "PassengerId" : strPassengerID,
            "DriverId"    : Singletons.sharedInstance.strDriverID,
            "BidId"       : strbidID,
            "Budget"      : strBudget,
            "Notes"       : notes,
            "Status"      : statusType
        
        ] as [String:AnyObject]
        print(param)
        webserviceForBidAccept(param as AnyObject) { (result, status) in
            if status{
                print(result)
                self.aryData = (result as! NSDictionary).object(forKey: "data") as! [String:AnyObject]
                let message = (result as! NSDictionary).object(forKey: "message") as! String
                 self.navigationController?.popViewController(animated: true)
                 UtilityClass.showAlert("", message: message, vc: self)
                Singletons.sharedInstance.BidAcceptData = self.aryData
                self.refreshControl.endRefreshing()
               
            }
            else {
                print(result)
                UtilityClass.defaultMsg(result:result)
                // UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
            }

        }
    }

}
