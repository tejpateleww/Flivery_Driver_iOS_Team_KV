//
//  ThemeView.swift
//  Flivery-Driver
//
//  Created by Mayur iMac on 27/03/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }


}
