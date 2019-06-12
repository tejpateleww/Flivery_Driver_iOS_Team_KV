//
//  TrackYourTripTableViewCell.swift
//  Flivery-Driver
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class TrackYourTripTableViewCell: UITableViewCell {

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
    
    // total Cell Height is 158.5
    
    // First View height is 81
   
    @IBOutlet var lblBookingIDTitle: UILabel!
//    @IBOutlet var lblPickupLocationTitle: UILabel!
   
//    @IBOutlet var lblDropOffLoationTitle: UILabel!
    @IBOutlet weak var lblDispatcherEmailTitle: UILabel!
   
    @IBOutlet weak var lblPassengerName: UILabel!
    
    @IBOutlet var lblTripDetails: UILabel!
    @IBOutlet var lblTripDetailsTitle: UILabel!
    @IBOutlet weak var lblFlightNumTitle: UILabel!
    
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblPickupTimeTitle: UILabel!
    @IBOutlet var lblPassengerNoTitle: UILabel!
    @IBOutlet var lblPassengerEmailTitle: UILabel!
    @IBOutlet weak var lblCarModelTitle: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblNotesTitle: UILabel!
    @IBOutlet weak var viewAllDetails: UIView! // Height is 72
    
    @IBOutlet weak var lblpassengerEmailDesc: UILabel!
    @IBOutlet weak var lblPassengerNoDesc: UILabel!
    @IBOutlet weak var lblPickupTimeDesc: UILabel!
    @IBOutlet weak var lblCarModelDesc: UILabel!
    @IBOutlet weak var lblFlightNumber: UILabel!
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblDispatcherNameTitle: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet var lblDispatcherName: UILabel!
    @IBOutlet var lblDispatcherEmail: UILabel!
    @IBOutlet var lblDispatcherNumber: UILabel!
    @IBOutlet var stackViewEmail: UIStackView!
    @IBOutlet var stackViewName: UIStackView!
    @IBOutlet var stackViewNumber: UIStackView!
    
    
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblBookingIdDesc: UILabel!
    @IBOutlet weak var btnTrakeYourTrip: UIButton!
    
    @IBOutlet weak var lblPickuplocationTitle: UILabel!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    
    @IBOutlet weak var lblDropOffLocationTitle: UILabel!
    @IBOutlet weak var lblDropoffLocationDescription: UILabel!
  
    @IBOutlet weak var lblShipperNameTitle: UILabel!
    @IBOutlet weak var lblShipperNameDesc: UILabel!
    
    @IBOutlet weak var lblContactNumberTitle: UILabel!
    @IBOutlet weak var lblContactNumberDesc: UILabel!
   
    @IBOutlet weak var lblParcelTypeTitle: UILabel!
    @IBOutlet weak var lblParcelTypeDesc: UILabel!
    
    @IBOutlet weak var lblPaymentTypeTitle: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    
    @IBOutlet weak var lblParcelWeightTitle: UILabel!
    @IBOutlet weak var lblParcelWeightDesc: UILabel!
    
    @IBOutlet weak var viewParcelImage: UIView!
    @IBOutlet weak var imgViewOfParcel: UIImageView!
    @IBOutlet weak var lblParcelImageTitle: UILabel!
    @IBOutlet weak var constantHeightOfViewParcelImage: NSLayoutConstraint! // 90.5
    

}
