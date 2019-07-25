//
//  BidListContainerViewController.swift
//  Flivery User
//
//  Created by eww090 on 28/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class BidListContainerViewController: BaseViewController {

    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollObject: UIScrollView!
    @IBOutlet weak var viewLineHeight: UIView!
    
    
    @IBOutlet var btnMyBid: UIButton!
    @IBOutlet var btnOpenBid: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bid List"
        setNavBarWithMenuORBack(Title: "Bid List".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        self.btnMyBid.setTitle("My Bid".localized, for: .normal)
        self.btnOpenBid.setTitle("Open Bid".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singletons.sharedInstance.isBidListOpened = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Singletons.sharedInstance.isBidListOpened = false
    }
    
    @objc func addTapped()
    {
        
    }

    @IBAction func btnMyBid(_ sender: Any) {

        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        constraintLeading.constant = 0
    }

    @IBAction func btnOpenBid(_ sender: Any) {

        scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
        constraintLeading.constant = viewLineHeight.frame.width
    }
   
}
//extension BidListContainerViewController : RefreshData{
//    func dataRefresh() {
//        if let bidListVC = self.children[1] as? OpenBidListViewController{
//            bidListVC.webserviceCallToGetOpenBidList()
//        }
//    }
//    
//    
//}
