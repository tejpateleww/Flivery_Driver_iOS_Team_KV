//
//  BidDetailsViewController.swift
//  Flivery User
//
//  Created by eww090 on 29/06/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class BidDetailsViewController: UIViewController
{
    //MARK:- ====== Outlets ======
    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var iconVehicle: UIImageView!
    @IBOutlet weak var lblBidCount: UILabel!
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblDropoffLocation: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblPickupDateTitle: UILabel!
    @IBOutlet weak var lblDeaheadTitle: UILabel!
    @IBOutlet weak var lblDistanceTitle: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPickupDate: UILabel!
    @IBOutlet weak var lblDeahead: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDriveOfferTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- ====== Variables ======
     private let refreshControl = UIRefreshControl()
     var bidDetail = [String:Any]()
     var aryData = [[String:AnyObject]]()
     var arrNumberOfOnlineCars : [[String:AnyObject]]!
     var arrBidDetails = [[String:AnyObject]]()
   
    
   //MARK:- ====== View Controller Life cycle ======
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.tblView.register(UINib(nibName: "NoDataFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataFoundTableViewCell")
        DataSetup()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
      //MARK:- ====== Data Setup ======
    func DataSetup(){
        if let distance = aryData[0]["Distance"] as? String{
            lblDistance.text = distance
        }
        if let PickupLocation = aryData[0]["PickupLocation"] as? String{
            lblPickupLocation.text = PickupLocation
        }
        if let price = aryData[0]["Budget"] as? String{
            lblPrice.text = "USD " + price
        }
        if let deadHead = aryData[0]["DeadHead"] as? String{
            lblDeahead.text = deadHead
        }
        if let pickup = aryData[0]["PickupDateTime"] as? String{
            let pickupDate : [String] = pickup.components(separatedBy: " ")
            var date : String = pickupDate[0]
            let datestring = UtilityClass.formattedDateFromString(dateString: date, withFormat: "dd MMMM")
            lblPickupDate.text =  datestring
        }
        if let droplocation = aryData[0]["DropoffLocation"] as? String{
            lblDropoffLocation.text = droplocation
        }
        
        if let modelName = aryData[0]["Name"] as? String{
            lblVehicleName.text = modelName
        }
        if let modelimage = aryData[0]["ModelImage"] as? String{
           iconVehicle.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + modelimage), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        }
        if let bids = aryData[0]["DriverBids"] as? String{
            lblBidCount.text = "Bids - " + bids
        }
    }
    
}
   /* func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return arrBidDetails.count > 0 ?  arrBidDetails.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if arrBidDetails.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataFoundTableViewCell") as! NoDataFoundTableViewCell
            cell.lblNoDataFound.text = "No driver has made any bid!"
            return cell
        } else {
        
        let customCell = self.tblView.dequeueReusableCell(withIdentifier: "DriverOffersListViewCell") as! DriverOffersListViewCell
        
        customCell.selectionStyle = .none
        customCell.imgProfile.layer.cornerRadius = self.view.frame.height/2
        customCell.imgProfile.clipsToBounds = true
        if let driverName = arrBidDetails[indexPath.row]["Fullname"] as? String{
            customCell.lblDriverName.text = driverName
        }
        if let imageUrl = arrBidDetails[indexPath.row]["DriverImage"] as? String{
             customCell.imgProfile.sd_setImage(with: URL(string: WebserviceURLs.kImageBaseURL + imageUrl), placeholderImage: UIImage(named: "iconProfilePicBlank"), options: [], completed: nil)
        }
        if let bidPrice = arrBidDetails[indexPath.row]["DriverBudget"] as? String{
            customCell.lblAmount.text = "USD " + bidPrice
        }
        if let driverNotes = arrBidDetails[indexPath.row]["DriverNotes"] as? String{
            customCell.lblDetail.text = driverNotes
        }
        if let ratingcount = arrBidDetails[indexPath.row]["DriverRating"] as? String{
            customCell.lblRate.text =  ratingcount
        }
        if let deadHead = aryData[indexPath.row]["DeadHead"] as? String{
            customCell.lblTime.text = deadHead
        }
        
        //        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
        //
        //        //
        //        //
        //        customCell.lblTicketID.text = "Ticket ID: \(dictData["TicketId"] as! String)"
        //        customCell.lblTitle.text = dictData["TicketTitle"] as! String
        //        let StrStatus = dictData["Status"] as! String
        //
        //        if StrStatus == "0"
        //        {
        //            customCell.lblStatus.text = "Pending"
        //        }
        //        if StrStatus == "1"
        //        {
        //            customCell.lblStatus.text = "Processing"
        //        }
        //        if StrStatus == "2"
        //        {
        //            customCell.lblStatus.text = "Complete"
        //        }
        //
        
        return customCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //        let dictData = arrTicketList[indexPath.row] as! [String : AnyObject]
        //
        //        //
        //        //
        //
        //        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //        viewController.strTicketID = dictData["TicketId"] as! String
        //        viewController.strTicketTile = dictData["TicketTitle"] as! String
        //
        //        self.navigationController?.pushViewController(viewController, animated: true)
        
        
         let dictData = arrReviewData[indexPath.row]
         if let cell = tblView.cellForRow(at: indexPath) as? HelpListViewCell
         {
         cell.lblDescription.isHidden = !cell.lblDescription.isHidden
         if cell.lblDescription.isHidden
         {
         expandedCellPaths.remove(indexPath)
         cell.lblDescription.text = ""
         cell.iconArrow.image = UIImage.init(named: "arrow-down-leftBlue")
         cell.viewCell.layer.borderColor = UIColor.clear.cgColor
         cell.viewCell.layer.borderWidth = 0.5
         }
         else
         {
         expandedCellPaths.insert(indexPath)
         cell.lblDescription.text = dictData["Answers"] as? String
         cell.iconArrow.image = UIImage.init(named: "arrow-down-Blue")
         cell.viewCell.layer.borderColor = UIColor.black.cgColor
         cell.viewCell.layer.borderWidth = 0.5
         }
         
         DispatchQueue.main.async {
         self.tblView.beginUpdates()
         self.tblView.endUpdates()
         }
         
         //            DispatchQueue.main.async {
         //                self.tableView.reloadRows(at: [indexPath], with: .automatic)
         //            }
         
         }
         
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return arrBidDetails.count != 0 ? UITableViewAutomaticDimension : self.tblView.frame.height
       
    }
*/


//"Id": "72",
//"PassengerId": "14",
//"ModelId": "3",
//"PickupLocation": "Excellent WebWorld, 203-206 City Center Opp Shukan Mall, Science City Rd, Science City, Sola, Ahmedabad, Gujarat 380060, India",
//"DropoffLocation": "Sola Cross Road, 132 Feet Ring Rd, Memnagar, Ahmedabad, Gujarat 380063, India",
//"PickupLat": "23.0726365",
//"PickupLng": "72.5164187",
//"DropOffLat": "23.0527303",
//"DropOffLon": "72.54663309999999",
//"PickupDateTime": "2019-07-02 17:39:24",
//"DeadHead": "11 mins",
//"Distance": "4.436",
//"ShipperName": "xyz",
//"Budget": "50",
//"Weight": "45",
//"Quantity": "5",
//"CardId": "18",
//"Notes": "xyccc",
//"Image": "images/passenger/f311b826f1984728c229dbef256bdf8d.png",
//"Status": "0",
//"CreatedDate": "2019-07-02 17:40:10",
//"DPassengerId": "14",
//"DriverId": "5",
//"BidId": "72",
//"DriverNotes": "test",
//"DriverStatus": "1",
//"DriverBudget": "50",
//"DriverDatetime": "2019-07-02 17:50:00",
//"DriverID": "5",
//"Fullname": "Jon Snow",
//"DriverImage": "images/driver/5/2ac088c174f62515e65f31636186d8aa.png",
//"UserId": "5",
//"DriverRating": "4"
