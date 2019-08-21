//
//  ParcelTblCell.swift
//  ODDS User
//
//  Created by EWW082 on 28/05/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class ParcelTblCell: UITableViewCell {

    @IBOutlet var lblParcelSizeTitle: UILabel!
    @IBOutlet var lblParcelSizeValue: UILabel!
    
    @IBOutlet var lblParcelWeightTitle: UILabel!
    @IBOutlet var lblParcelWeightValue: UILabel!
    
    @IBOutlet var lblParcelPriceTitle: UILabel!
    @IBOutlet var lblParcelPriceValue: UILabel!
    
    @IBOutlet var lblParcelTypeTitle: UILabel!
    @IBOutlet var lblParcelTypeValue: UILabel!
    
    @IBOutlet var StackParcelSize: UIStackView!
    @IBOutlet var StackParcelWeight: UIStackView!
    @IBOutlet var StackParcelPrice: UIStackView!
    @IBOutlet var StackParcelType: UIStackView!
    
    @IBOutlet var lblParcelQueue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
