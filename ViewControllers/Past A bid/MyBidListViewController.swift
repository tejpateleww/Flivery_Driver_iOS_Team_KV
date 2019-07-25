//
//  MyBidListViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit

class MyBidListViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate
{

     //MARK:- ====== Outlets ======
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- ====== Variables ======
    private let refreshControl = UIRefreshControl()
     var aryData = [[String:AnyObject]]()
   
   //MARK:- ====== View Controller Life cycle======
    override func viewDidLoad()
    {
        print(Singletons.sharedInstance.strDriverID)
        super.viewDidLoad()
        tblView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        webserviceCallToGetDriverBidList()
       self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        webserviceCallToGetDriverBidList()
        setNavBarWithMenuORBack(Title: "Bid List".localized, LetfBtn: kIconBack, IsNeedRightButton: false, isTranslucent: false)

    }
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    func nevigateToBack()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TabbarController.self) {
                //                self.sideMenuController?.embed(centerViewController: controller)
                break
            }
        }
    }
     //MARK: ===== Data Refresh Method ======
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        webserviceCallToGetDriverBidList()
    }

    //MARK: ===== API Call Get Bid List ======
    func webserviceCallToGetDriverBidList()
    {
        webserviceForDriverBidList( AnyObject.self.self as AnyObject) { (result,status) in
        
            if (status) {
                    print(result)

                    self.aryData = (result as! NSDictionary).object(forKey: "data") as! [[String:AnyObject]]
            Singletons.sharedInstance.DriverBidData = self.aryData
            
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
    //MARK: ===== API Call Get Bid List ======
    @objc func ViewDetailsAction(_ sender:UIButton) {
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PostABidViewController") as! PostABidViewController
        detailVC.BidData = [aryData[sender.tag]]
        detailVC.isThisDetail = true
        self.navigationController?.pushViewController(detailVC, animated: true)
//        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "BidDetailsViewController") as! BidDetailsViewController
//        detailVC.aryData = [aryData[sender.tag]]
//        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
     //MARK: ===== Tableview Datasource and Delegate ======
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aryData.count > 0 ? aryData.count : 1
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
            customCell.btnViewDetails.addTarget(self, action:#selector(ViewDetailsAction(_:)), for: .touchUpInside)
        customCell.selectionStyle = .none
        if let bids = aryData[indexPath.row]["DriverBids"] as? String{
                customCell.lblBidCount.text = "Bids - ".localized + bids
            }
        if let distance = aryData[indexPath.row]["Distance"] as? String{
            customCell.lblDistance.text = distance
        }
        if let PickupLocation = aryData[indexPath.row]["PickupLocation"] as? String{
            customCell.lblPickupLocation.text = PickupLocation
        }
        if let price = aryData[indexPath.row]["Budget"] as? String{
            customCell.lblPrice.text = "\(currency) " + price
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
            
            if let BidID =  aryData[indexPath.row]["BidId"] as? Int {
                customCell.lblBidId.text = "Bid Id - ".localized + "\(BidID)"
            } else if let BidID =  aryData[indexPath.row]["BidId"] as? String {
                customCell.lblBidId.text =  "Bid Id - ".localized + "\(BidID)"
            }
            
        if let modelimage = aryData[indexPath.row]["ModelImage"] as? String{
             customCell.iconVehicle.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + modelimage), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        }
        return customCell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if aryData.count == 0 {
            return self.tblView.frame.height
        } else {
            return UITableView.automaticDimension
        }
    }
}
//
//"Id": "86",
//"PassengerId": "15",
//"ModelId": "3",
//"PickupLocation": "Sarkhej - Gandhinagar Hwy, Bodakdev, Ahmedabad, Gujarat 380054, India",
//"DropoffLocation": "Nehru Nagar Cir, Tagore Park, Tapovan Society, Ambawadi, Ahmedabad, Gujarat 380015, India",
//"PickupLat": "23.030513",
//"PickupLng": "72.5075401",
//"DropOffLat": "23.022146",
//"DropOffLon": "72.54274819999999",
//"PickupDateTime": "2019-07-03 19:40:00",
//"DeadHead": "11 mins",
//"Distance": "4.069",
//"ShipperName": "Test Test",
//"Budget": "500",
//"Weight": "500",
//"Quantity": "2",
//"CardId": "20",
//"Notes": "",
//"Image": "",
//"Status": "0",
//"CreatedDate": "2019-07-03 19:10:14",
//"Name": "Big Truck",
//"ModelImage": "images/model/big-truck-min.png"
//
