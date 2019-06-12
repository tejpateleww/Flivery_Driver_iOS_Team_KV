//
//  MultipleBookingTrackingViewController.swift
//  Flivery-Driver
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class MultipleBookingTrackingViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - Outlets
    // ----------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNodataFound: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var expandedCellPaths = Set<IndexPath>()
    var aryData: [[String:Any]] = [[:]]
  
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarWithMenuORBack(Title: "Your Running Trip", LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)
        
        self.tableView.isHidden = true
        webserviceOfGetAllCurrentBookings()
        
//        self.title = "Your Running Trip"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalizable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setLocalizable() {
        self.lblNodataFound.text = "No data found.".localized
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    @objc func btnTrackYourTrip(_ sender: UIButton) {
        
        let currrentData = self.aryData[sender.tag]
        Singletons.sharedInstance.bookingId = currrentData["Id"] as! String
        NotificationCenter.default.post(name: NotificationTrackRunningTrip, object: currrentData)
        self.navigationController?.popViewController(animated: true)
    }
    
    // ----------------------------------------------------
    // MARK: - Webservice Methods
    // ----------------------------------------------------

    func webserviceOfGetAllCurrentBookings() {
        
        let param = Singletons.sharedInstance.strDriverID + "/" + Singletons.sharedInstance.deviceToken
        webserviceForTrackYourCurrentTrip(param as AnyObject) { (result, status) in
            
            if (status) {
                
                if let res = result as? [String:Any] {
                    if let bookingInfo = res["BookingInfo"] as? [[String:Any]] {
                        if bookingInfo.count != 0 {
                            self.aryData = bookingInfo
                            self.tableView.reloadData()
                            
                            if self.aryData.count > 0 {
                                self.lblNodataFound.isHidden = true
                                self.tableView.isHidden = false
                            } else {
                                self.lblNodataFound.isHidden = false
                                self.tableView.isHidden = true
                            }
                        }
                    }
                }        
            } else {
              
                self.lblNodataFound.isHidden = false
                self.tableView.isHidden = true
               
                if let res = result as? String {
                    UtilityClass.showAlert("App Name".localized, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    if let errorMessage = resDict[ GetResponseMessageKey()] as? String {
                        UtilityClass.showAlert("App Name".localized, message: errorMessage, vc: self)
                    }
                }
                else if let resAry = result as? NSArray {
                    let msg = (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as? String ?? (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as? String ?? ""
                    
                    UtilityClass.showAlert("App Name".localized, message: msg, vc: self)
                }
            }
        }
    }
}


extension MultipleBookingTrackingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currrentData = self.aryData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackYourTripTableViewCell", for: indexPath) as! TrackYourTripTableViewCell
        cell.selectionStyle = .none
        
        cell.lblPassengerName.text = currrentData["PassengerName"] as? String
        
        cell.lblBookingId.text = cell.lblBookingId.text?.uppercased()
        cell.lblBookingIdDesc.text = ": " + (currrentData["Id"] as? String ?? "N/A")
        
        cell.lblPickuplocationTitle.text = cell.lblPickuplocationTitle.text?.uppercased()
        cell.lblPickUpLocation.text = ": " + (currrentData["PickupLocation"] as? String ?? "N/A")
        
        cell.lblDropOffLocationTitle.text = cell.lblDropOffLocationTitle.text?.uppercased()
        cell.lblDropoffLocationDescription.text = ": " + (currrentData["DropoffLocation"] as? String ?? "N/A")
        
        cell.lblPickupTimeTitle.text = cell.lblPickupTimeTitle.text?.uppercased()
        cell.lblPickupTimeDesc.text = ": " + (currrentData["PickupDateTime"] as? String ?? "N/A")
        
        cell.lblShipperNameTitle.text = cell.lblShipperNameTitle.text?.uppercased()
        cell.lblShipperNameDesc.text = ": " + (currrentData["PassengerName"] as? String ?? "N/A")
        
        cell.lblContactNumberTitle.text = cell.lblContactNumberTitle.text?.uppercased()
        cell.lblContactNumberDesc.text = ": " + (currrentData["PassengerContact"] as? String ?? "N/A")
        
        cell.lblParcelTypeTitle.text = cell.lblParcelTypeTitle.text?.uppercased()
        cell.lblParcelTypeDesc.text = ": " + (currrentData["GoodsName"] as? String ?? "N/A")
        
        cell.lblPaymentTypeTitle.text = cell.lblPaymentTypeTitle.text?.uppercased()
        cell.lblPaymentType.text = ": " + (currrentData["PaymentType"] as? String ?? "N/A")
        
        cell.lblParcelWeightTitle.text = cell.lblParcelWeightTitle.text?.uppercased()
        
        if let goodsWeight = currrentData["GoodsWeight"] as? String {
            if goodsWeight != "" {
                 cell.lblParcelWeightDesc.text = ": " + goodsWeight + " kg"
            } else {
                cell.lblParcelWeightDesc.text = ": " + "N/A"
            }
        } else {
            cell.lblParcelWeightDesc.text = ": " + "N/A"
        }
        
        if let imgURL = currrentData["Image"] as? String {
            if imgURL != "" {
                cell.viewParcelImage.isHidden = false
                cell.constantHeightOfViewParcelImage.constant = 92
                cell.imgViewOfParcel.sd_setShowActivityIndicatorView(true)
                cell.imgViewOfParcel.sd_setIndicatorStyle(.gray)
                cell.imgViewOfParcel.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + imgURL), completed: nil)
            } else {
                cell.viewParcelImage.isHidden = true
                cell.constantHeightOfViewParcelImage.constant = 0
            }
        } else {
            cell.viewParcelImage.isHidden = true
            cell.constantHeightOfViewParcelImage.constant = 0
        }
        
        cell.lblParcelImageTitle.text =  cell.lblParcelImageTitle.text?.uppercased()
        cell.btnTrakeYourTrip.tag = indexPath.row
        cell.btnTrakeYourTrip.addTarget(self, action: #selector(self.btnTrackYourTrip(_:)), for: .touchUpInside)
        
        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TrackYourTripTableViewCell {
            cell.viewAllDetails.isHidden = !cell.viewAllDetails.isHidden
            if cell.viewAllDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}
