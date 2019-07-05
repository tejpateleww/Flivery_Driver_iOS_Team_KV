//
//  DriverOffersListViewCell.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class DriverOffersListViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
