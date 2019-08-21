//
//  FutureBookingVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 16/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FutureBookingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNodataFound: UILabel!
    
    
    var strNotAvailable: String = "N/A"
    
//    let hView = HeaderView()
    
    var dataPatam = [String:AnyObject]()
    var aryData = NSArray()
    var expandedCellPaths = Set<IndexPath>()
    var selectedCellIndexPath: IndexPath?
    
    let selectedCellHeight: CGFloat = 205
    let unselectedCellHeight: CGFloat = 105
    
    var drieverId = String()
    var bookingID = String()
    
//     var labelNoData = UILabel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = ThemeYellowColor
        
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()

//        labelNoData = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        self.labelNoData.text = "Loading..."
//        labelNoData.textAlignment = .center
//        self.view.addSubview(labelNoData)
//        self.tableView.isHidden = true
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        self.tableView.addSubview(self.refreshControl)

    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
//        webserviceOFFurureBooking()
        setLocalizable()
    }
    
    func setLocalizable()
    {
        self.lblNodataFound.text = "No data found.".localized
         self.title = "My Job".localized
    }

    override func loadView() {
        super.loadView()
        
//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if Connectivity.isConnectedToInternet() == false {
            self.refreshControl.endRefreshing()
            return
        }
        webserviceOFFurureBooking()
        if self.aryData.count > 0 {
            self.lblNodataFound.isHidden = true
        } else {
            self.lblNodataFound.isHidden = false
        }
        tableView.reloadData()
       
    }

  
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if section == 0 {
//
//            if aryData.count == 0 {
//                return 1
//            }
//            else {
//                return aryData.count
//            }
//        }
//        else {
//            return 1
//        }
        
        return aryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "FutureBookingTableViewCell") as! FutureBookingTableViewCell
        
//        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! FutureBookingTableViewCell
        
        cell.selectionStyle = .none
        
        cell.lblPickUpTimeTitle.text = "Pick Up Time :".localized
        cell.lblTripDistance.text = "Distance Travel :".localized
        cell.lblpeymentType.text = "Payment Type :".localized
       
        cell.viewCell.layer.cornerRadius = 10
        cell.viewCell.clipsToBounds = true
//        cell2.selectionStyle = .none
  
//        if aryData.count != 0 {
        
//            if indexPath.section == 0 {
//
                 let data = aryData.object(at: indexPath.row) as! NSDictionary
               
                cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
        

//            if let TimeAndDate = data.object(forKey: "PickupDateTime") as? String {
//                cell.lblTimeAndDateAtTop.text = setTimeStampToDate(timeStamp: TimeAndDate)
//            }
//            else {
//                cell.lblTimeAndDateAtTop.text = strNotAvailable
//            }
        
        cell.lblBookingId.text = "\("Booking Id".localized): \(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Id", isNotHave: strNotAvailable))"
    

        cell.lblDate.text = (checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable)).components(separatedBy: " ")[0]
        
//         checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PaymentType", isNotHave: strNotAvailable)

                cell.lblDropOffLocationDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DropoffLocation", isNotHave: strNotAvailable) //data.object(forKey: "PickupLocation") as? String // DropoffLocation
                cell.lblDateAndTime.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable)
                cell.lblPickupTimeValue.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable)
                //data.object(forKey: "PickupDateTime") as? String
                cell.lblPickupLocation.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupLocation", isNotHave: strNotAvailable) // data.object(forKey: "DropoffLocation") as? String  // PickupLocation
                cell.lblPassengerNoDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PassengerContact", isNotHave: strNotAvailable) //data.object(forKey: "PassengerContact") as? String
                cell.lblTripDestanceDesc.text = "\(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable)) km" //data.object(forKey: "TripDistance") as? String
                cell.lblCarModelDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable) //data.object(forKey: "Model") as? String
                
                cell.btnAction.tag = Int((data.object(forKey: "Id") as? String)!)!
                cell.btnAction.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
                cell.lblFlightNumber.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "FlightNumber", isNotHave: strNotAvailable) // data.object(forKey: "FlightNumber") as? String
                cell.lblNotes.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Notes", isNotHave: strNotAvailable) //data.object(forKey: "Notes") as? String
        
        
                    cell.lblPaymentType.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: GetPaymentTypeKey(), isNotHave: strNotAvailable)
        
                 // data.object(forKey: "PaymentType") as? String
        
                cell.viewSecond.isHidden = !expandedCellPaths.contains(indexPath)
 
//            }
        
        
        cell.lblDispatcherName.text = ""
        cell.lblDispatcherEmail.text = ""
        cell.lblDispatcherNumber.text = ""
        cell.lblDispatcherNameTitle.text = ""
        cell.lblDispatcherEmailTitle.text = ""
        cell.lblDispatcherNumberTitle.text = ""
        
        
        cell.stackViewEmail.isHidden = true
        cell.stackViewName.isHidden = true
        cell.stackViewNumber.isHidden = true
        
        if((data.object(forKey: "DispatcherDriverInfo")) != nil)
        {
            print("There is driver info and passengger name is \(String(describing: cell.lblPassengerName.text))")
            
            cell.lblDispatcherName.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Email"] as? String
            cell.lblDispatcherEmail.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Fullname"] as? String
            cell.lblDispatcherNumber.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["MobileNo"] as? String
            cell.lblDispatcherNameTitle.text = "DISPACTHER NAME"
            cell.lblDispatcherEmailTitle.text = "DISPATCHER EMAIL"
            cell.lblDispatcherNumberTitle.text = "DISPATCHER TITLE"
            
            cell.stackViewEmail.isHidden = false
            cell.stackViewName.isHidden = false
            cell.stackViewNumber.isHidden = false
        }
        
        */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
        
        if aryData.count > 0 {
            //            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            cell.lblBookingIdTitle.text = "Booking Id".localized.uppercased()
            cell.lblPickupAddressTitle.text = "Pickup Location".localized.uppercased()
            cell.lblDropoffAddressTitle.text = "Dropoff Location".localized.uppercased()
            cell.lblPickUpTimeTitle.text = "Booking Date".localized.uppercased()
            cell.lblPassengerNoTitle.text = "Passenger No".localized.uppercased()
            cell.lblTripDistanceTitle.text = "Delivery Distance".localized.uppercased()
            cell.lblPaymentTypeTitle.text = "Payment Type".localized.uppercased()
            cell.lblVehicleModelTitle.text = "Vehicle Model".localized.uppercased()
            cell.lblParcelTypeTitle.text = "Parcel Type".localized.uppercased()
            cell.lblParcelWeightTitle.text = "Parcel Weight".localized.uppercased()
            cell.lblParcelImageTitle.text = "Parcel Image".localized.uppercased()
            cell.btnCancelRequest.setTitle("Track Your Trip".localized, for: .normal)
            cell.btnCancelRequest.titleLabel?.font = UIFont.bold(ofSize: 8.0)
            
            //            cell.viewCell.layer.cornerRadius = 10
            //            cell.viewCell.clipsToBounds = true
            
            let dictData = aryData[indexPath.row] as! NSDictionary
            
            if let BookingID = dictData[ "Id"] as? String {
                //                cell.lblBookingId.text = "\("Booking Id".localized) : \(BookingID)"
                cell.lblBookingId.text = ": \(BookingID)"
            }
            
            
            
            //            cell.lblBookingID.attributedText = formattedString
            if let Createdate = dictData[ "CreatedDate"] as? String {
                cell.lblDateAndTime.text =  Createdate
            }
            
            //            if let Notes = dictData["Notes"] as? String {
            //                cell.lblNotes.text = Notes
            //            }
            
            if let PickupLocation = dictData[ "PickupLocation"] as? String {
                cell.lblPickupAddress.text = ": " + PickupLocation // PickupLocation
            }
            if let DropOffAddress = dictData[ "DropoffLocation"] as? String {
                cell.lblDropoffAddress.text =  ": " + DropOffAddress  // DropoffLocation
            }
//            cell.lblPickUpTimeTitle.text = "Pickup Date Time".uppercased()
            if let pickupTime = dictData[ "PickupDateTime"] as? String {
                if pickupTime == "" {
                    cell.lblPickUpTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickUpTime.text = ": " +  pickupTime
                    //                        setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            //            if let vehicleType = dictData["Model"] as? String {
            //                cell.lblVehicleType.text = ": " + vehicleType
            //            }
            
            if let tripDistance = dictData["TripDistance"] as? String {
                if let distance = Double(tripDistance) {
                    cell.lblTripDistance.text = ": " + String(format: "%.2f KM", distance)
                }
            }
            
            if let PaymentType = dictData["PaymentType"] as? String {
                cell.lblPaymentType.text = ": " + PaymentType
            }
            
            if let ParcelArray = dictData["parcel_info"] as? [[String:Any]] {
                cell.arrParcel = ParcelArray
                cell.setParcelDetail()
            }
            
            
            if let strParcelImage = dictData["ParcelImage"] as? String {
                cell.imgParcelImage.sd_setShowActivityIndicatorView(true)
                cell.imgParcelImage.sd_setIndicatorStyle(.gray)
                cell.imgParcelImage?.sd_setImage(with: URL(string: strParcelImage), completed: { (image, error, cacheType, url) in
                    cell.imgParcelImage.sd_removeActivityIndicator()
                    cell.imgParcelImage.contentMode = .scaleAspectFit
                })
            }
            
            cell.ViewDeliveredParcelImage.isHidden = true
            
            
            if let passengerName = dictData["PassengerName"] as? String {
                cell.lblDriverName.text =  passengerName
            }
            
            if let passengerNo = dictData["PassengerContact"] as? String {
                cell.lblPassengerNo.text = ": " +  passengerNo
                
            }
            
            if let parcelPrice = dictData["ParcelPrice"] as? String {
                if let price = Double(parcelPrice) {
                    cell.lblParcelPriceValue.text = ": \(currency)" + String(format: "%.2f", price)
                }
            }
            
            if let VehicleModel = dictData["Model"] as? String  {
                cell.lblVehicleModel.text = ": " + VehicleModel
            }
            
            if let ParcelDetail = dictData["Parcel"] as? [String:Any] {
                if let ParcelType = ParcelDetail["Name"] as? String {
                    cell.lblParcelType.text  = ": " +  ParcelType
                }
            }
            
            if let Labour = dictData["Labour"] as? String , Labour  != "" {
                cell.lblLabour.text = String(format: ": %.2f", (Labour as NSString).doubleValue)
            }else if let Labour = dictData["Labour"] as? Double {
                cell.lblLabour.text = String(format: ": %.2f", Labour)
            } else if let Labour = dictData["Labour"] as? Int {
                cell.lblLabour.text = String(format: ": %.2f", ("\(Labour)" as NSString).doubleValue)
             }
            
            if let ParcelWeight = dictData["Weight"] as? String , ParcelWeight  != "" {
                cell.lblParcelWeight.text = String(format: ": %.2f Kgs", (ParcelWeight as NSString).doubleValue)
            }else if let ParcelWeight = dictData["Weight"] as? Double {
                cell.lblParcelWeight.text = String(format: ": %.2f Kgs", ParcelWeight)
            }
            
            if let id = dictData["Id"] as? Int {
                cell.btnAcceptRequest.tag = id
                cell.btnAcceptRequest.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
            }else if let id = dictData["Id"] as? String {
                cell.btnAcceptRequest.tag = Int(id) ?? 0
                cell.btnAcceptRequest.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
            }
            //            cell.btnAcceptRequest.tag = Int(dictData ["Id"] as! String)!)!
            
            //            let myString = aryData[ indexPath.row] as! Dictionary ["DriverName"] as? String
            //            cell.lblDriverName.text = myString
            //
            //            bookinType = aryData[ indexPath.row]["BookingType"] as! String
            //            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
            //            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            cell.btnCancelRequest.tag = indexPath.row
            cell.btnCancelRequest.layer.cornerRadius = 5
            cell.btnCancelRequest.layer.masksToBounds = true
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        }
        
        
            return cell
//        }
//        else {
//
//            cell2.frame.size.height = self.tableView.frame.size.height
//
//            return cell2
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//
//        if aryData.count != 0 {
//
//            if indexPath.section == 0 {
//
        /*
                if let cell = tableView.cellForRow(at: indexPath) as? FutureBookingTableViewCell {
                    cell.viewSecond.isHidden = !cell.viewSecond.isHidden
                    if cell.viewSecond.isHidden {
                        expandedCellPaths.remove(indexPath)
                    } else {
                        expandedCellPaths.insert(indexPath)
                    }
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    //            tableView.deselectRow(at: indexPath, animated: true)
                }
        */
//            }
//        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? UpCommingTableViewCell {
            cell.viewDetails.isHidden = !cell.viewDetails.isHidden
            if cell.viewDetails.isHidden {
                expandedCellPaths.remove(indexPath)
            } else {
                expandedCellPaths.insert(indexPath)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }
    }
    

    @objc func btnActionForSelectRecord(sender: UIButton) {
        if Connectivity.isConnectedToInternet() == false {
            UtilityClass.showAlert("App Name".localized, message: "Sorry! Not connected to internet".localized, vc: self)
            return
        }
        
        bookingID = String((sender.tag))
        
        webserviceOfFutureAcceptDispatchJobRequest()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setTimeStampToDate(timeStamp: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: timeStamp) //according to date format your date string
        print(date ?? "")

        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy" //Specify your format that you want
        let strDate: String = dateFormatter.string(from: date!)
        
        return strDate
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOFFurureBooking()
    {
        
        let id = Singletons.sharedInstance.strDriverID
        
        webserviceForFutureBooking(id as AnyObject) { (result, status) in
            
            if (status) {
//                print(result)
                
                self.aryData = ((result as! NSDictionary).object(forKey: "dispath_job") as! NSArray)
//                if(self.aryData.count == 0)
//                {
//                    self.labelNoData.text = "Please check back later"
//                    self.tableView.isHidden = true
//                }
//                else {
//                    self.labelNoData.removeFromSuperview()
//                    self.tableView.isHidden = false
//                }
                
                self.refreshControl.endRefreshing()
                if self.aryData.count > 0 {
                    self.lblNodataFound.isHidden = true
                } else {
                    self.lblNodataFound.isHidden = false
                }
                self.tableView.reloadData()
                
            }
            else {
                self.refreshControl.endRefreshing()
                if let res = result as? String {
                    UtilityClass.showAlert("App Name".localized, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("App Name".localized, message: resDict.object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("App Name".localized, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
            }
        }
    }
    
    var audioPlayer:AVAudioPlayer!
    
    func playSound(strName : String) {
        
//        guard let url = Bundle.main.url(forResource: strName, withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer.numberOfLoops = 1
//            audioPlayer.play()
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
    }
    
    func stopSound() {
        
//        guard let url = Bundle.main.url(forResource: "\(RingToneSound)", withExtension: "mp3") else { return }
//        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//            
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer.stop()
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
    }
    
    
    
    func webserviceOfFutureAcceptDispatchJobRequest() {
        
        drieverId = Singletons.sharedInstance.strDriverID

        let sendParam = drieverId + "/" + bookingID
     
        webserviceForFutureAcceptDispatchJobRequest(sendParam as AnyObject) { (result, status) in

            if (status) {
//                print(result)
                //needToCheck
                let alert = UIAlertController(title: "App Name".localized , message: ((result as! [String:AnyObject])[GetResponseMessageKey()] as! String), preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
//                    let myJobs = (self.navigationController?.children[0] as! TabbarController).childViewControllers.last as! MyJobsViewController
                    self.webserviceOFFurureBooking()
//                    myJobs.btnPendingJobsClicked(myJobs.btnPendingJobs)
                    if let VC = self.parent as? MyJobsViewController
                    {
                        if let VCPending = self.parent?.children[0] as? PendingJobsListVC
                        {
                            VCPending.webserviceofPendingJobs()
                        }
                        VC.btnPendingJobsClicked(VC.btnPendingJobs)
                    }
                 })
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
//                print(result)
                
        
                if let res = result as? String {
                    UtilityClass.showAlert("App Name".localized, message: res, vc: self)
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.showAlert("App Name".localized, message: resDict.object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.showAlert("App Name".localized, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: GetResponseMessageKey()) as! String, vc: self)
                }
            }
        }
        
    }
    
    
 
}
