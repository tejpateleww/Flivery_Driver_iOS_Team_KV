//
//  OpenBidListViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class OpenBidListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tblView: UITableView!
    private let refreshControl = UIRefreshControl()
    var aryData = [[String:AnyObject]]()
    var arrNumberOfOnlineCars : [[String:AnyObject]]!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
       webserviceCallToGetDriverBids()
        self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
    
        //arrNumberOfOnlineCars = Singletons.sharedInstance.arrCarLists as? [[String : AnyObject]]
        // Do any additional setup after loading the view.
    }
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        webserviceCallToGetDriverBids()
    }
       
    //MARK: ===== API Call Get Bids ======
    func webserviceCallToGetDriverBids()
    {
        webserviceForDriverBid("" as AnyObject) { (result, status) in
            if (status) {
                print(result)
                
                self.aryData = (result as! NSDictionary).object(forKey: "data") as! [[String:AnyObject]]
                Singletons.sharedInstance.DriverBidList = self.aryData
                self.tblView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print(result)
                UtilityClass.defaultMsg(result:result)
                //  UtilityClass.setCustomAlert(title: "", message:UtilityClass.defaultMsg(result:result), completionHandler: nil)
            }
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return aryData.count > 0 ?  aryData.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if aryData.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataFoundTableViewCell") as! NoDataFoundTableViewCell
            cell.lblNoDataFound.text = "No Data Found !"
            return cell
        } else {
            
            let customCell = self.tblView.dequeueReusableCell(withIdentifier: "MyBidListViewCell") as! MyBidListViewCell
            customCell.btnViewDetails.tag = indexPath.row
            customCell.btnViewDetails.addTarget(self, action:#selector(sendOfferBtnAction(_:)), for: .touchUpInside)
            customCell.selectionStyle = .none
            
            if let distance = aryData[indexPath.row]["Distance"] as? String{
                customCell.lblDistance.text = distance
            }
            if let PickupLocation = aryData[indexPath.row]["PickupLocation"] as? String{
                customCell.lblPickupLocation.text = PickupLocation
            }
            if let price = aryData[indexPath.row]["Budget"] as? String{
                customCell.lblPrice.text = "USD " + price
            }
            if let deadHead = aryData[indexPath.row]["DeadHead"] as? String{
                customCell.lblDeadhead.text = deadHead
            }
            if let pickup = aryData[indexPath.row]["PickupDateTime"] as? String{
                let pickupDate : [String] = pickup.components(separatedBy: " ")
                var date : String = pickupDate[0]
                let dateString = UtilityClass.formattedDateFromString(dateString: date, withFormat:"dd MMMM" )
                customCell.lblPickupDate.text = dateString
            }
            if let droplocation = aryData[indexPath.row]["DropoffLocation"] as? String{
                customCell.lblDropofLocation.text = droplocation
            }
            if let modelName = aryData[indexPath.row]["Name"] as? String{
                customCell.lblVehicleName.text = modelName
            }
            if let modelimage = aryData[indexPath.row]["ModelImage"] as? String{
                customCell.iconVehicle.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + modelimage), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
            }
            return customCell
            
        }
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return aryData.count != 0 ?  UITableView.automaticDimension : self.tblView.frame.height
    }
    @objc func sendOfferBtnAction(_ sender:UIButton) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PostABidViewController") as! PostABidViewController
        detailVC.BidData = [aryData[sender.tag]]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}



