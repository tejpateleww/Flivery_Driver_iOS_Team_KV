//
//  TripInfoCompletedTripVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import MarqueeLabel

class TripInfoCompletedTripVC: UIViewController {
    var delegate: CompleterTripInfoDelegate!
    
    var dictData = NSDictionary()
    
   
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var lblBookingID: UILabel!
    
    
    @IBOutlet weak var imgTripToDestinationIcon: UIImageView!
    //    @IBOutlet weak var lblDropOffLocationInFo: UILabel!
//    @IBOutlet weak var lblPickUPLocationInFo: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnViewCompleteTripData: UIView!
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    @IBOutlet weak var stackViewSpecialExtraCharge: UIStackView!
    
  
    @IBOutlet weak var lblPickupLocation: MarqueeLabel!
    @IBOutlet weak var lblDropOffLocation: MarqueeLabel!
    
    @IBOutlet var lblPickupTimeTitle: UILabel!
    @IBOutlet var lblDropoffTimeTitle: UILabel!
    @IBOutlet var lblDistanceTravelledTitle: UILabel!
    @IBOutlet var lblPaymentTypeTitle: UILabel!
    @IBOutlet var lblBookingFeeTitle: UILabel!
    @IBOutlet var lblTripFareTitle: UILabel!
    @IBOutlet var lblWaitingCostTitle: UILabel!
    @IBOutlet var lblWaitingTimeTitle: UILabel!
    @IBOutlet var lblLessTitle: UILabel!
    @IBOutlet var lblPromoCodeTitle: UILabel!
    @IBOutlet var lblTotlaAmountTitle: UILabel!
    @IBOutlet var lblTripStatusTitle: UILabel!
    @IBOutlet weak var lblTipAmountTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet var lblParcelTypeTitle: UILabel!
    @IBOutlet var lblParcelWeightTitle: UILabel!
    @IBOutlet var lblWeightChargeTitle: UILabel!
    
    @IBOutlet weak var lblDistanceFareTitle: UILabel!
    
    
    @IBOutlet var lblPickupTime: UILabel!
    @IBOutlet var lblDropoffTime: UILabel!
    @IBOutlet var lblDistanceTravelled: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblBookingFee: UILabel!
    @IBOutlet var lblTripFare: UILabel!
    @IBOutlet var lblWaitingCost: UILabel!
    @IBOutlet var lblWaitingTime: UILabel!
    @IBOutlet var lblPromoCode: UILabel!
    @IBOutlet var lblTax: UILabel!
    @IBOutlet var lblTotlaAmount: UILabel!
    @IBOutlet var lblTripStatus: UILabel!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet var lblParcelType: UILabel!
    @IBOutlet var lblParcelWeight: UILabel!
    @IBOutlet var imgParcel: UIImageView!
    @IBOutlet var lblWeightCharge: UILabel!

    
    @IBOutlet weak var PickupTimeStack: UIStackView!
    @IBOutlet weak var DropoffTimeStack: UIStackView!
    @IBOutlet weak var PaymentTypeStack: UIStackView!
    @IBOutlet weak var DistanceTravelledStack: UIStackView!
    @IBOutlet weak var BookingFeeStack: UIStackView!
    @IBOutlet weak var TripFareStack: UIStackView!
    @IBOutlet weak var TipStack: UIStackView!
    @IBOutlet weak var WaitingCostStack: UIStackView!
    @IBOutlet weak var WaitingTimeStack: UIStackView!
    @IBOutlet weak var PromoCodeStack: UIStackView!
    @IBOutlet weak var TotalAmountStack: UIStackView!
    @IBOutlet weak var TripStatusStack: UIStackView!
    
    @IBOutlet weak var DistanceFareStack: UIStackView!
    
    
    
//    @IBOutlet weak var lblTripDistanceInfo: UILabel!
//    @IBOutlet weak var lblBaseFareInFo: UILabel!
//    @IBOutlet weak var lblDistanceFare: UILabel!
//    @IBOutlet weak var lblWaitingTimeInFo: UILabel!
//
//    @IBOutlet weak var lblBookingChargeDetail: UILabel!
//    @IBOutlet weak var lblWaitingTimecostDetails: UILabel!
//    @IBOutlet weak var lblWaitinfTimeDetails: UILabel!
//    @IBOutlet weak var lblWaitingTimeCost: UILabel!
//    @IBOutlet weak var lblDistanceFareInFo: UILabel!
//    @IBOutlet weak var lblNightFare: UILabel!
//    @IBOutlet weak var lblTollFree: UILabel!
//
//
//    @IBOutlet weak var txtSpecialExtraCharge: UILabel!
//    @IBOutlet weak var lblSubTotal: UILabel!
//
//
//
//    @IBOutlet weak var lblTaxInfo: UILabel!
//    @IBOutlet weak var lblBookingChargeInfo: UILabel!
//    @IBOutlet weak var lblDiscount: UILabel!
//    @IBOutlet weak var lblTax: UILabel!
//    @IBOutlet weak var lblGrandTotal: UILabel!
//
//    @IBOutlet weak var lblGrandTotalINfo: UILabel!
//    @IBOutlet weak var lblFlightNumber: UILabel!
//    @IBOutlet weak var lblNote: UILabel!
   
    
//    @IBOutlet weak var lblNoteInFo: UILabel!
//    @IBOutlet weak var lblBaseFare: UILabel!
//    @IBOutlet weak var lblTripDistance: UILabel!
//    @IBOutlet weak var lblDiatnceFare: UILabel!
//    @IBOutlet weak var lblSpecialExtraCharge: UILabel!
   
    
    @IBOutlet weak var lblTripDetail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgTripToDestinationIcon = Utilities.changeColorOfIconTo(theImageView: imgTripToDestinationIcon, color: ThemeYellowColor)

        if Singletons.sharedInstance.pasengerFlightNumber == "" {
            stackViewFlightNumber.isHidden = true
        }
        else {
//            lblFlightNumber.text = Singletons.sharedInstance.pasengerFlightNumber
//            stackViewFlightNumber.isHidden = false
        }
        
        if Singletons.sharedInstance.passengerNote == "" {
            stackViewNote.isHidden = true
        }
        else {
//            lblNote.text = Singletons.sharedInstance.passengerNote
//            stackViewNote.isHidden = false
        }
        
        setData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setLocalization()
    }
    func setLocalization()
    {
        lblTripDetail.text = "Delivery Info".localized
//        lblPickupLocation.text =  "Address".localized
//        lblDropOffLocation.text = "Address".localized
        
        lblTripFareTitle.text = "Base Fare".localized
        lblDistanceTravelledTitle.text = "Trip Distance".localized
        lblDistanceFareTitle.text  = "Distance Fare".localized
        lblWaitingCostTitle.text  = "Waiting Cost".localized
        lblWaitingTimeTitle.text  = "Waiting Time".localized
//        lblTipAmountTitle.text  = "Tip by Passenger".localized
        lblBookingFeeTitle.text  = "Booking Charge".localized
        lblPromoCodeTitle.text  = "Discount".localized
        lblTaxTitle.text  = "Tax" .localized
        lblTotlaAmountTitle.text  = "Grand Total".localized
        lblLessTitle.text  = "(incl tax)".localized
        btnOK.setTitle("OK".localized, for: .normal) 
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnViewCompleteTripData.layer.cornerRadius = 10
        btnViewCompleteTripData.layer.masksToBounds = true
        
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        // ------------------------------------------------------------
    
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
        dictData = NSMutableDictionary(dictionary: (dictData.object(forKey: "details") as! NSDictionary))
        print(dictData)
        
        lblPickupTimeTitle.text = "Pickup Date Time".localized.uppercased()
        lblDropoffTimeTitle.text = "Dropoff Date Time".localized.uppercased()   
        lblPickupLocation.text = dictData.object(forKey: "PickupLocation") as? String
        lblDropOffLocation.text = dictData.object(forKey: "DropoffLocation") as? String
        
        
        let PickTime = Double(dictData.object(forKey: "PickupTime") as? String ?? "0")
        let dropoffTime = Double(dictData.object(forKey: "DropTime") as! String)
        let unixTimestamp = PickTime //as Double//as! Double//dictData.object(forKey: "PickupTime")
        let unixTimestampDrop = dropoffTime
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp ?? 00.00))
        let dateDrop = Date(timeIntervalSince1970: TimeInterval(unixTimestampDrop ?? 00.00))
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        let strDateDrop = dateFormatter.string(from: dateDrop)
        
        lblPickupTime.text = ": " + strDate//dictData.object(forKey: "PickupDateTime") as? String
        
        lblDropoffTime.text = ": " + strDateDrop //dictData.object(forKey: "PickupDateTime") as? String
//        lblTollFree.text = dictData.object(forKey: "TollFee") as? String
        
        /*
        if let BookingID = dictData.object(forKey: "Id") as? String {
            lblBookingID.text = "Booking Id : \(BookingID)"
        }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let strTripDate = dateFormatter.string(from: dateDrop)
        lblDate.text = strTripDate

 
        if let PaymentType = dictData.object(forKey: "PaymentType") as? String {
            lblPaymentType.text = PaymentType
        }
         
         let strdate1 = dictData.object(forKey: "CreatedDate") as? String
         let arrdate = strdate1?.components(separatedBy: " ")
         let finalDate = arrdate![0].replacingOccurrences(of: "-", with: "/")
         lblDate.text = finalDate//dictData.object(forKey: "PickupDate") as? String
         
         
         var strSpecial = String()
         
         if let special = dictData.object(forKey: "Special") as? String {
         strSpecial = special
         } else if let special = dictData.object(forKey: "Special") as? Int {
         strSpecial = String(special)
         }
         lblTripStatus.text = dictData.object(forKey: "Status") as? String
         stackViewSpecialExtraCharge.isHidden = true
         
         if strSpecial == "1" {
         stackViewSpecialExtraCharge.isHidden = false
         
         //            if let SpecialExtraCharge = dictData.object(forKey: "SpecialExtraCharge") as? String {
         //                lblSpecialExtraCharge.text = SpecialExtraCharge
         //            } else if let SpecialExtraCharge = dictData.object(forKey: "SpecialExtraCharge") as? Double {
         //                lblSpecialExtraCharge.text = String(SpecialExtraCharge)
         //            }
         }

 */

        if let ParcelDetail = dictData["Parcel"] as? [String:Any] {
            if let ParcelType = ParcelDetail["Name"] as? String {
                self.lblParcelType.text  = ": " +  ParcelType
            }
        }
        
        if let ParcelWeight = dictData["Weight"] as? String , ParcelWeight  != "" {
            self.lblParcelWeight.text = String(format: ": %.2f Kgs", (ParcelWeight as NSString).doubleValue)
        }else if let ParcelWeight = dictData["Weight"] as? Double {
            self.lblParcelWeight.text = String(format: ": %.2f Kgs", ParcelWeight)
        }
        
        if let strParcelImage = dictData["ParcelImage"] as? String {
            self.imgParcel.sd_setShowActivityIndicatorView(true)
            self.imgParcel.sd_setIndicatorStyle(.gray)
            self.imgParcel.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL +  strParcelImage), completed: { (image, error, cacheType, url) in
                self.imgParcel.sd_removeActivityIndicator()
                self.imgParcel.contentMode = .scaleAspectFit
            })
        }

        if let PaymentType = dictData["PaymentType"] as? String {
            self.lblPaymentType.text = ": " + PaymentType
        }
        
        if let TripFare = dictData.object(forKey: "TripFare") as? String {
            lblTripFare.text = ": \(currency) \(String(format: "%.2f", Double(TripFare) ?? 0.0))"
        }
        
        if let TripDistance = dictData.object(forKey: "TripDistance") as? String {
            lblDistanceTravelled.text = ": \(String(format: "%.2f", Double(TripDistance) ?? 0.0)) km"
        }
        
        if let DistanceFare = dictData.object(forKey: "DistanceFare") as? String {
            lblDistanceFare.text = ": \(currency) \(String(format: "%.2f", Double(DistanceFare) ?? 0.0))"
        }
        
        if let WeightCharge = dictData["WeightCharge"] as? String {
            self.lblWeightCharge.text = ": \(currency)" + WeightCharge
        }
        
        if let WaitingTime = dictData.object(forKey: "WaitingTime") as? String {
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(WaitingTime) ?? 0)
            lblWaitingTime.text = ": \(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):\(getStringFrom(seconds: s))"
        }
        
        if let WaitingCost = dictData.object(forKey: "WaitingTimeCost") as? String {
            lblWaitingCost.text = ": \(currency) \(WaitingCost)"
//            "\(String(format: "%.2f", Double(WaitingCost)!)) \(currency)"
        }
        
        if let Tip = dictData.object(forKey: "TollFee") as? String {
            lblTipAmount.text =   (Tip != "" && Tip != "0") ? ": \(currency) \(String(format: "%.2f", Double(Tip) ?? 0.0))" : ": \(currency) 0"
        }
        
        if let BookingFee = dictData.object(forKey: "BookingCharge") as? String {
            lblBookingFee.text = (BookingFee != "" && BookingFee != "0") ? ": \(currency) \(String(format: "%.2f", Double(BookingFee) ?? 0.0))" : ": \(currency) 0"
        }
        
        if let discount = dictData.object(forKey: "Discount") as? String {
            lblPromoCode.text = (discount != "" && discount != "0") ? ": \(currency) \(String(format: "%.2f", Double(discount) ?? 0.0))" : ": \(currency) 0"
        }
        
        if let Tax = dictData.object(forKey: "Tax") as? String {
            lblTax.text = (Tax != "" && Tax != "0") ? ": \(currency) \(Tax)" : ": \(currency) 0"
        }
        
        if let GrandTotal = dictData.object(forKey: "GrandTotal") as? String {
            lblTotlaAmount.text = (GrandTotal != "" && GrandTotal != "0") ? ": \(currency) \(GrandTotal)" : ": \(currency) 0"
        }
        
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func btnOK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if Singletons.sharedInstance.passengerType == "other" || Singletons.sharedInstance.passengerType == "others"
        {
//            self.completeTripInfo()
        }
        else
        {
            self.delegate.didRatingCompleted()
        }
        Singletons.sharedInstance.passengerType = ""
    }
    
}
