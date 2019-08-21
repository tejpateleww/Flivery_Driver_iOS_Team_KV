//
//  UpCommingTableViewCell.swift
//  ODDS-Driver
//
//  Created by Apple on 10/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class UpCommingTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet var lblBookingIdTitle: UILabel!
    @IBOutlet var lblPassengerNoTitle: UILabel!
    @IBOutlet var lblVehicleModelTitle: UILabel!
    @IBOutlet var lblParcelTypeTitle: UILabel!
    @IBOutlet var lblBookingDateTitle: UILabel!
    
    @IBOutlet weak var lblDropoffAddressTitle: UILabel!
    @IBOutlet weak var lblPickupAddressTitle: UILabel!
    @IBOutlet weak var lblDropoffAddress: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet var AppartmentStack: UIStackView!
    
    @IBOutlet var ApartmentTopConstraint: NSLayoutConstraint!
    @IBOutlet var lblApartmentNumber: UILabel!
    @IBOutlet weak var btnCancelRequest: ThemeButton!
    
    @IBOutlet weak var btnAcceptRequest: UIButton!
 
    @IBOutlet weak var lblPickUpTimeTitle: UILabel!
    @IBOutlet var lblDropoffTimeTitle: UILabel!
    @IBOutlet var lblParcelWeightTitle: UILabel!
    @IBOutlet var lblParcelImageTitle: UILabel!
    @IBOutlet var lblDeliveredParcelImageTitle: UILabel!
    
//    @IBOutlet weak var lblVehicleTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
//    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    
    ///Change
    @IBOutlet weak var lblPassengerNo: UILabel!
    @IBOutlet var lblPassengerEmailTitle: UILabel!
    
    @IBOutlet weak var lblTripDistanceTitle: UILabel!
    @IBOutlet weak var lblTripDistance: UILabel!
    @IBOutlet weak var lblNotes: UILabel!

    @IBOutlet weak var vwStackNote: UIStackView!
    
    
    @IBOutlet var imgParcelImage: UIImageView!
    @IBOutlet var imgDeliveredParcelImage: UIImageView!
    
    @IBOutlet var ViewParcelImage: UIView!
    @IBOutlet var ViewDeliveredParcelImage: UIView!
    
    @IBOutlet var ParcelTableView: UITableView!
    
    @IBOutlet var lblParcelPriceTitle: UILabel!
    @IBOutlet var lblParcelPriceValue: UILabel!
    
    //Change for past jobs
    @IBOutlet weak var lblDropofTime: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTripFare: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!

    @IBOutlet weak var lblDiscount: UILabel!

    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    @IBOutlet var lblVehicleModel: UILabel!
    @IBOutlet var lblParcelType: UILabel!
    @IBOutlet var lblLabour: UILabel!
    @IBOutlet var lblpassengerEmail: UILabel!
    @IBOutlet var lblDistanceFare: UILabel!
    @IBOutlet var lblWeightCharge: UILabel!
    
    @IBOutlet var lblDeliveryDistanceTitle: UILabel!
    @IBOutlet var lblDeliveryDurationTitle: UILabel!
    @IBOutlet var lblDeliveryFareTitle: UILabel!
    @IBOutlet var lblDistanceFareTitle: UILabel!
    @IBOutlet var lblWeightChargeTitle: UILabel!
    @IBOutlet var lblTaxTitle: UILabel!
    @IBOutlet var lblDiscountTitle: UILabel!
    @IBOutlet var lblSubTotalTitle: UILabel!
    @IBOutlet var lblBookingChargeTitle: UILabel!
    @IBOutlet var lblGrandTotalTitle: UILabel!
    @IBOutlet var lblPassengerNoteTitle: UILabel!
    
    @IBOutlet var lblParcelInformation: UILabel!
    
    // if cancel status hide this all
    
    @IBOutlet weak var vwPickupTIme: UIStackView!
    
    @IBOutlet weak var vwDropTime: UIStackView!
    
    @IBOutlet var imgTripStatus: UIImageView!
    /// For distance show in km
    @IBOutlet weak var vwDistance: UIStackView!
    
    @IBOutlet weak var vwTripDuration: UIStackView!
    @IBOutlet weak var vwTripFare: UIStackView!
    @IBOutlet weak var vwBookingCharge: UIStackView!
    @IBOutlet weak var vwTax: UIStackView!
    @IBOutlet weak var vwDiscount: UIStackView!
    @IBOutlet weak var vwSubtotal: UIStackView!
    @IBOutlet weak var vwGrandTotal: UIStackView!
    @IBOutlet weak var vwPaymentType: UIStackView!
    @IBOutlet weak var vwDistanceFare: UIStackView!
    @IBOutlet weak var vwWeightCharge: UIStackView!
    @IBOutlet var vwParcelDetails: UIStackView!
    @IBOutlet var vwParcelWeight: UIStackView!
    
    
    @IBOutlet var lblParcelWeight: UILabel!
    
    //////////////////
    
    @IBOutlet var tblHeightConstraint: NSLayoutConstraint!
    
    var arrParcel:[[String:Any]] = []
    
    func setParcelDetail() {
        
        ParcelTableView.dataSource = self
        ParcelTableView.delegate = self
        ParcelTableView.reloadData()
        ParcelTableView.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.tblHeightConstraint.constant = self.ParcelTableView.contentSize.height + 20
        }
    }
}


//MARK:- UITableView Datasource & Delegate Methods

extension UpCommingTableViewCell : UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrParcel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ParcelCell = self.ParcelTableView.dequeueReusableCell(withIdentifier: "ParcelTblCell", for: indexPath) as! ParcelTblCell
        let parcelData = self.arrParcel[indexPath.row]
        ParcelCell.lblParcelSizeTitle.text = "PARCEL SIZE"
        ParcelCell.selectionStyle = .none
        if let ParcelSize = parcelData["ParcelSize"] as? String {
            if(ParcelSize.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
            {
                ParcelCell.lblParcelSizeValue.text = "-"
            }
            else
            {
                ParcelCell.lblParcelSizeValue.text = ": " + ParcelSize
//                    + " \(MeasurementSign)"
            }
        }
        
        ParcelCell.lblParcelWeightTitle.text = "PARCEL WEIGHT"
        if let ParcelWeight = parcelData["ParcelWeight"] as? String {
            if(ParcelWeight.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
            {
                ParcelCell.lblParcelWeightValue.text = "-"
            }
            else
            {
                ParcelCell.lblParcelWeightValue.text = ": " + ParcelWeight
//                    + " \(WeightSign)"
            }
        }
        
        ParcelCell.lblParcelQueue.text = "PARCEL - " + "\(indexPath.row + 1)"
        ParcelCell.lblParcelPriceTitle.text = "PARCEL PRICE"
        if let ParcelPrice = parcelData["ParcelPrice"] as? String {
            ParcelCell.lblParcelPriceValue.text = ": " + currency + ParcelPrice
        }
        
        ParcelCell.lblParcelTypeTitle.text = "PARCEL TYPE"
        if let ParcelType = parcelData["ParcelType"] as? String {
            ParcelCell.lblParcelTypeValue.text = ": " + ParcelType
        }
        if let ParcelType = parcelData["ParcelType"] as? String {
            if ParcelType == "Box" {
                ParcelCell.StackParcelSize.isHidden = false
                ParcelCell.StackParcelWeight.isHidden = false
            } else {
                ParcelCell.StackParcelSize.isHidden = true
                ParcelCell.StackParcelWeight.isHidden = true
            }
        }
        return ParcelCell
    }
}
