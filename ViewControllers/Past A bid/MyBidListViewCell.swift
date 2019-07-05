//
//  MyBidListViewCell.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class MyBidListViewCell: UITableViewCell {

    
    
    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    
    @IBOutlet weak var lblDropofLocation: UILabel!
    @IBOutlet weak var lblBidCount: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var iconVehicle: UIImageView!
    
    @IBOutlet weak var lblPickupDateTitle: UILabel!
    @IBOutlet weak var lblDeadheadTitle: UILabel!
    @IBOutlet weak var lblDistanceTitle: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    
    
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblDeadhead: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    @IBOutlet weak var btnViewDetails: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
