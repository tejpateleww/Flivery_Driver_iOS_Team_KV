//
//  PendingJobsListVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 14/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SocketIO

class PendingJobsListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //    let socket = UtilityClass.socketManager()
    var strNotAvailable: String = "N/A"
    
    @IBOutlet weak var lblNodataFound: UILabel!
    
    //-------------------------------------------------------------
    // MARK: - Global Declaration
    //-------------------------------------------------------------
    //    let activityData = ActivityData()
    @IBOutlet weak var tableView: UITableView!
    
    
    var aryData = NSArray()
    var aryPendingJobs = NSMutableArray()
    
    var isSelectedIndex = Int()
    
    var selectedCellIndexPath: IndexPath?
    let selectedCellHeight: CGFloat = 158.5
    let unselectedCellHeight: CGFloat = 81
    
    var isVisible: Bool = true
    var labelNoData = UILabel()
    
    
    lazy var refreshControl: UIRefreshControl =
        {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            refreshControl.tintColor = ThemeYellowColor
            
            return refreshControl
    }()
    
    func dismissSelf() {
        
        self.navigationController?.popViewController(animated: true)
        
        
        //        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // UtilityClass.showACProgressHUD()
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
//        webserviceofPendingJobs()
        setLocalizable()
         self.title = "My Job".localized
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        if Connectivity.isConnectedToInternet() == false {
            self.refreshControl.endRefreshing()
            return
        }
        webserviceofPendingJobs()
        if self.aryPendingJobs.count > 0 {
            self.lblNodataFound.isHidden = true
            self.tableView.isHidden = false
        } else {
            self.lblNodataFound.isHidden = false
        }
        tableView.reloadData()
        
    }
    func setLocalizable()
    {
        self.lblNodataFound.text = "No data found.".localized
        
    }
    
    
    //-------------------------------------------------------------
    // MARK: - TableView Methods
    //-------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return aryPendingJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingJobsListTableViewCell") as! PendingJobsListTableViewCell
        //        let cell2 = tableView.dequeueReusableCell(withIdentifier: "NoDataFound") as! PendingJobsListTableViewCell
        
        cell.selectionStyle = .none
        cell.lblPickupTimeTitle.text = "Pick Up Time :".localized
        cell.lblTripDetailsTitle.text = "Distance Travel :".localized
        cell.lblPaymentTypeTitle.text = "Payment Type :".localized
        cell.btnStartTrip.setTitle("Start Trip".localized, for: .normal)
        cell.btnStartTrip.titleLabel?.lineBreakMode = .byWordWrapping
        cell.viewCell.layer.cornerRadius = 10
        cell.viewCell.clipsToBounds = true
        
        let data = aryPendingJobs.object(at: indexPath.row) as! NSDictionary
        
        cell.lblPassengerName.text = data.object(forKey: "PassengerName") as? String
        cell.lblDateTime.text = (checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable)).components(separatedBy: " ")[0]
//            data.object(forKey: "CreatedDate") as? String
        
        if let TimeAndDate: String = data.object(forKey: "PickupDateTime") as? String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date = dateFormatter.date(from: TimeAndDate)
            
            
            dateFormatter.dateFormat = "HH:mm dd/MM/YYYY"///this is what you want to convert format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let timeStamp = dateFormatter.string(from: date!)
            
            //            cell.lblTimeAndDateAtTop.text = "\(timeStamp)"
        }
        
        cell.lblBookingId.text = "\("Booking Id".localized): \(checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Id", isNotHave: strNotAvailable))"
        
        
        //        checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupLocation", isNotHave: strNotAvailable) //
        
        //        cell.lblDropoffLocation.text = ""
        cell.lblDropoffLocationDescription.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "DropoffLocation", isNotHave: strNotAvailable) // data.object(forKey: "PickupLocation") as? String // DropoffLocation
        cell.lblDateAndTime.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "CreatedDate", isNotHave: strNotAvailable) //data.object(forKey: "CreatedDate") as? String
        
        cell.lblPickUpLocation.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupLocation", isNotHave: strNotAvailable)
        // data.object(forKey: "DropoffLocation") as? String // PickupLocation
        cell.lblpassengerEmailDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PassengerEmail", isNotHave: strNotAvailable) // data.object(forKey: "PassengerEmail") as? String
        cell.lblPassengerNoDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PassengerContact", isNotHave: strNotAvailable) // data.object(forKey: "PassengerContact") as? String
        cell.lblPickupTimeDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "PickupDateTime", isNotHave: strNotAvailable) // data.object(forKey: "PickupDateTime") as? String
        cell.lblCarModelDesc.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Model", isNotHave: strNotAvailable) // data.object(forKey: "Model") as? String
        cell.lblFlightNumber.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "FlightNumber", isNotHave: strNotAvailable) //data.object(forKey: "FlightNumber") as? String
        cell.lblNotes.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "Notes", isNotHave: strNotAvailable) //data.object(forKey: "Notes") as? String
        
        cell.lblPaymentType.text = checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: GetPaymentTypeKey(), isNotHave: strNotAvailable)
        
        cell.btnStartTrip.tag = Int((data.object(forKey: "Id") as? String)!)!
        cell.btnStartTrip.addTarget(self, action: #selector(self.strtTrip(sender:)), for: .touchUpInside)
        
        cell.viewAllDetails.isHidden = !expandedCellPaths.contains(indexPath)
        
        var tripDistance = String()
        if let strTripDistance = data.object(forKey: "TripDistance") as? String {
            tripDistance = strTripDistance
        } else if let intTripDistance = data.object(forKey: "TripDistance") as? Int {
            tripDistance = "\(intTripDistance)"
        }
        
        let strStatus = data.object(forKey: "Status") as! String
        Singletons.sharedInstance.DriverTripCurrentStatus = strStatus
        let strBookingStatus = data.object(forKey: "BookingType") as! String
        let strOntheWay = data.object(forKey: "OnTheWay") as? String
        if strBookingStatus == "Book Now"
        {
            cell.btnStartTrip.isHidden = true
        }
        else
        {
            
            if strStatus == kAcceptTripStatus && strOntheWay! == "1"
            {
                cell.btnStartTrip.isHidden = true
            }
            else //if strStatus == kAcceptTripStatus && strOntheWay! == 0 //|| strStatus == kPendingTripStatus //kPendingJob
            {
                cell.btnStartTrip.isHidden = false
                cell.btnStartTrip.tag = Int((data.object(forKey: "Id") as? String)!)!
                cell.btnStartTrip.addTarget(self, action: #selector(self.strtTrip(sender:)), for: .touchUpInside)
            }
            //            else
            //            {
            //                cell.btnStartTrip.isHidden = true
            //            }
        }
        
        cell.lblTripDetails.text = "\("N/A" != checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable) ? checkDictionaryHaveValue(dictData: data as! [String : AnyObject], didHaveValue: "TripDistance", isNotHave: strNotAvailable) : "0") km" //
        
        cell.lblDispatcherName.text = ""
        cell.lblDispatcherEmail.text = ""
        cell.lblDispatcherNumber.text = ""
        cell.lblDispatcherName.text = ""
        cell.lblDispatcherEmailTitle.text = ""
        cell.lblDispatcherNumber.text = ""
        
        cell.stackViewEmail.isHidden = true
        cell.stackViewName.isHidden = true
        cell.stackViewNumber.isHidden = true
        
        if((data.object(forKey: "DispatcherDriverInfo")) != nil)
        {
            print("There is driver info and passengger name is \(String(describing: cell.lblPassengerName.text))")
            
            cell.lblDispatcherName.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Email"] as? String
            cell.lblDispatcherEmail.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["Fullname"] as? String
            cell.lblDispatcherNumber.text = (data.object(forKey: "DispatcherDriverInfo") as? [String:AnyObject])!["MobileNo"] as? String
            cell.lblDispatcherName.text = "DISPACTHER NAME"
            cell.lblDispatcherEmailTitle.text = "DISPATCHER EMAIL"
            cell.lblDispatcherNumber.text = "DISPATCHER TITLE"
            
            cell.stackViewEmail.isHidden = false
            cell.stackViewName.isHidden = false
            cell.stackViewNumber.isHidden = false
        }
        */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpCommingTableViewCell") as! UpCommingTableViewCell
        
        if aryPendingJobs.count > 0 {
            //            let currentData = (aryData.object(at: indexPath.row) as! [String:AnyObject])
            
            cell.selectionStyle = .none
            
//            cell.lblPickupAddressTitle.text = "PICK UP LOCATION".localized
//            cell.lblDropoffAddressTitle.text = "DROP OFF LOCATION".localized
//            cell.lblPickUpTimeTitle.text = "BOOKING DATE".localized
////            cell.lblTripDistanceTitle.text = "PASSENGER EMAIL".localized
//            cell.lblPaymentTypeTitle.text = "Payment Type".localized.uppercased()
            cell.lblBookingIdTitle.text = "Booking Id".localized.uppercased()
            cell.lblPickupAddressTitle.text = "Pickup Location".localized.uppercased()
            cell.lblDropoffAddressTitle.text = "Dropoff Location".localized.uppercased()
            cell.lblPickUpTimeTitle.text = "Booking Date".localized.uppercased()
            cell.lblPassengerEmailTitle.text = "Passenger Email".localized.uppercased()
            cell.lblPassengerNoTitle.text = "Passenger No".localized.uppercased()
            cell.lblTripDistanceTitle.text = "Delivery Distance".localized.uppercased()
            cell.lblVehicleModelTitle.text = "Vehicle Model".localized.uppercased()
            cell.lblParcelTypeTitle.text = "Parcel Type".localized.uppercased()
            cell.lblParcelWeightTitle.text = "Parcel Weight".localized.uppercased()
            cell.lblParcelImageTitle.text = "Parcel Image".localized.uppercased()
            cell.lblParcelInformation.text = "Parcel Information".localized.uppercased()
            cell.lblDeliveryFareTitle.text = "Delivery Fare".localized.uppercased()
            cell.lblPassengerNoteTitle.text = "Passenger Note".localized.uppercased()
            cell.lblTaxTitle.text = "Tax".localized.uppercased()
            cell.lblGrandTotalTitle.text = "Grand Total".localized.uppercased()

            cell.btnCancelRequest.setTitle("On The Way".localized, for: .normal)
            cell.btnCancelRequest.titleLabel?.font = UIFont.bold(ofSize: 8.0)
            
            //            cell.viewCell.layer.cornerRadius = 10
            //            cell.viewCell.clipsToBounds = true
            
            //            let dictData = aryData[indexPath.row] as! NSDictionary
            let dictData = aryPendingJobs.object(at: indexPath.row) as! NSDictionary
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
            
            if let ApartmentNumber = dictData[ "ApartmentNo"] as? String, ApartmentNumber != "" {
                cell.lblApartmentNumber.text =  ": \(ApartmentNumber)"  // Apartment Number
                cell.AppartmentStack.isHidden = false
                cell.ApartmentTopConstraint.constant = 24.0
            } else {
                cell.AppartmentStack.isHidden = true
                cell.ApartmentTopConstraint.constant = 5.0
            }
            
            if let pickupTime = dictData[ "PickupDateTime"] as? String {
                if pickupTime == "" {
                    cell.lblPickUpTime.text = "Date and Time not available"
                }
                else {
                    cell.lblPickUpTime.text = ": " +  pickupTime
                    //                        setTimeStampToDate(timeStamp: pickupTime)
                }
            }
            
            if let tripDistance = dictData["TripDistance"] as? String {
                if let distance = Double(tripDistance) {
                    cell.lblTripDistance.text = ": " + String(format: "%.2f KM", distance)
                }
            }
            
            
            if let vehicleType = dictData["Model"] as? String {
                 cell.lblVehicleModel.text = ": " + vehicleType
            }
            
            
            if let PaymentType = dictData["PaymentType"] as? String {
                cell.lblPaymentType.text = ": " + PaymentType
            }
            
            if let ParcelArray = dictData["parcel_info"] as? [[String:Any]] {
                cell.arrParcel = ParcelArray
                cell.setParcelDetail()
            }
            
            var ImageBaseUrl:String = ""
            if let BidID = dictData[ "BidId"] as? String, BidID != "0" {
                cell.vwTripFare.isHidden = false
                cell.vwTax.isHidden  = false
                cell.vwGrandTotal.isHidden = false
                
                if let email = dictData["PassengerEmail2"] as? String {
                    cell.lblpassengerEmail.text = ": " + email
                }
                
                if let passengerNo = dictData["PassengerContact2"] as? String {
                    cell.lblPassengerNo.text = ": " +  passengerNo
                }
                
                if let tripFare = dictData["TripFare"] as? String {
                    cell.lblTripFare.text = ": \(currency)" + tripFare
                }
                
                if let tax = dictData["Tax"] as? String {
                    cell.lblTax.text = ": \(currency)" + tax
                }
                
                if let grandTotal = dictData["GrandTotal"] as? String {
                    cell.lblGrandTotal.text = ": \(currency)" + grandTotal
                }
                
                
            } else {
                cell.vwTripFare.isHidden = true
                cell.vwTax.isHidden  = true
                cell.vwGrandTotal.isHidden = true
                
                ImageBaseUrl  = WebserviceURLs.kImageBaseURL
                
                if let email = dictData["PassengerEmail"] as? String {
                    cell.lblpassengerEmail.text = ": " + email
                }
                
                if let passengerNo = dictData["PassengerContact"] as? String {
                    cell.lblPassengerNo.text = ": " +  passengerNo
                }
            }

            
            if let strParcelImage = dictData["ParcelImage"] as? String {
                cell.imgParcelImage.sd_setShowActivityIndicatorView(true)
                cell.imgParcelImage.sd_setIndicatorStyle(.gray)
                cell.imgParcelImage?.sd_setImage(with: URL(string: strParcelImage), completed: { (image, error, cacheType, url) in
                    cell.imgParcelImage.sd_removeActivityIndicator()
                    cell.imgParcelImage.contentMode = .scaleAspectFit
                })
            }
            
            if let ParcelDetail = dictData["Parcel"] as? [String:Any] {
                if let ParcelType = ParcelDetail["Name"] as? String {
                    cell.lblParcelType.text  = ": " +  ParcelType
                }
            }
            
            if let ParcelWeight = dictData["Weight"] as? String , ParcelWeight  != "" {
                cell.lblParcelWeight.text = String(format: ": %.2f Kgs", (ParcelWeight as NSString).doubleValue)
            }else if let ParcelWeight = dictData["Weight"] as? Double {
                cell.lblParcelWeight.text = String(format: ": %.2f Kgs", ParcelWeight)
            }
            
            cell.ViewDeliveredParcelImage.isHidden = true
            
            
            if let passengerName = dictData["PassengerName"] as? String {
                cell.lblDriverName.text =  passengerName
            }
            

            
            if let parcelPrice = dictData["ParcelPrice"] as? String {
                if let price = Double(parcelPrice) {
                    cell.lblParcelPriceValue.text = ": \(currency)" + String(format: "%.2f", price)
                }
            }
            
            
            
            if let note = dictData["Notes"] as? String {
                cell.vwStackNote.isHidden = note.isEmpty
                cell.lblNotes.text = ": " +  note
                
            }
            
            let strStatus = dictData.object(forKey: "Status") as! String
            Singletons.sharedInstance.DriverTripCurrentStatus = strStatus
            let strBookingStatus = dictData.object(forKey: "BookingType") as! String
            let strOntheWay = dictData.object(forKey: "OnTheWay") as? String
            if strBookingStatus == "Book Now" {
                cell.btnCancelRequest.isHidden = true
            }else
            {
                
                if strStatus == kAcceptTripStatus && strOntheWay! == "1"
                {
                    cell.btnCancelRequest.isHidden = true
                }
                else //if strStatus == kAcceptTripStatus && strOntheWay! == 0 //|| strStatus == kPendingTripStatus //kPendingJob
                {
                    cell.btnCancelRequest.isHidden = false
                    cell.btnCancelRequest.tag = Int((dictData.object(forKey: "Id") as? String)!)!
                    cell.btnCancelRequest.addTarget(self, action: #selector(self.strtTrip(sender:)), for: .touchUpInside)
                }
                //            else
                //            {
                //                cell.btnStartTrip.isHidden = true
                //            }
            }
            
            
            /*
             if let id = dictData["Id"] as? Int {
             cell.btnAcceptRequest.tag = id
             cell.btnAcceptRequest.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
             }else if let id = dictData["Id"] as? String {
             cell.btnAcceptRequest.tag = Int(id) ?? 0
             cell.btnAcceptRequest.addTarget(self, action: #selector(self.btnActionForSelectRecord(sender:)), for: .touchUpInside)
             }
             */
            
            
            //            cell.btnAcceptRequest.tag = Int(dictData ["Id"] as! String)!)!
            
            //            let myString = aryData[ indexPath.row] as! Dictionary ["DriverName"] as? String
            //            cell.lblDriverName.text = myString
            //
            //            bookinType = aryData[ indexPath.row]["BookingType"] as! String
            //            cell.btnCancelRequest.setTitle("Cancel Request".localized, for: .normal)
            //            cell.btnCancelRequest.addTarget(self, action: #selector(self.CancelRequest), for: .touchUpInside)
            //            cell.btnCancelRequest.tag = indexPath.row
            cell.btnCancelRequest.layer.cornerRadius = 5
            cell.btnCancelRequest.layer.masksToBounds = true
            
            cell.viewDetails.isHidden = !expandedCellPaths.contains(indexPath)
        }
        
        
        return cell
    }
    
    
    var expandedCellPaths = Set<IndexPath>()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let cell = tableView.cellForRow(at: indexPath) as? PendingJobsListTableViewCell {
//            cell.viewAllDetails.isHidden = !cell.viewAllDetails.isHidden
//            if cell.viewAllDetails.isHidden {
//                expandedCellPaths.remove(indexPath)
//            } else {
//                expandedCellPaths.insert(indexPath)
//            }
//            tableView.beginUpdates()
//            tableView.endUpdates()
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
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceofPendingJobs() {
        
        let driverID = Singletons.sharedInstance.strDriverID
        
        webserviceForPendingBooking(driverID as AnyObject) { (result, status) in
            
            if (status)
            {
                //                print(result)
                
                self.aryData = ((result as! NSDictionary).object(forKey: "history") as! NSArray)
                self.aryPendingJobs.removeAllObjects()
                self.refreshControl.endRefreshing()
//                self.aryPendingJobs = self.aryData as! NSMutableArray
                self.getPendingJobs()
                
//                if(self.aryPendingJobs.count == 0)
//                {
//                    self.labelNoData.text = "Please check back later"
//                    self.tableView.isHidden = true
//                }
//                else
//                {
//                    self.labelNoData.removeFromSuperview()
//
//                    if self.tableView != nil
//                    {
//                        self.tableView.isHidden = false
//                    }
//                    else
//                    {
//                        self.tableView.delegate = self
//                        self.tableView.dataSource = self
//                        self.tableView.isHidden = false
//                    }
//                }
                
                if self.aryPendingJobs.count > 0 {
                    self.lblNodataFound.isHidden = true
                    self.tableView.isHidden = false
                } else {
                    self.lblNodataFound.isHidden = false
                }
                
                self.tableView.reloadData()
                
            }
            else {
                //                print(result)
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
    
    func getPendingJobs() {
        
        aryPendingJobs.removeAllObjects()
        refreshControl.endRefreshing()
        for i in 0..<aryData.count {
            
            let dataOfAry = (aryData.object(at: i) as! NSDictionary)
            
//            let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
//
//            if strHistoryType == "onGoing" {
                self.aryPendingJobs.add(dataOfAry)
                
//            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Socket: Notify Passenger For Advance Trip
    //-------------------------------------------------------------
    
    @objc func strtTrip(sender: UIButton)
    {
        //        if (Singletons.sharedInstance.isRequestAccepted == true)
        //        {
        //            UtilityClass.showAlert(appName.kAPPName, message: "Please complete your current trip first", vc: self)
        //        }
        //        else
        //        {
        if Connectivity.isConnectedToInternet() == false {
            UtilityClass.showAlert("App Name".localized, message: "Sorry! Not connected to internet".localized, vc: self)
            return
        }
        
        if(Singletons.sharedInstance.driverDuty != "1") {
            UtilityClass.showAlert("App Name".localized, message: "Get online First.".localized, vc: self)
            return
        }
        let bookingID = String((sender.tag))
        
        Singletons.sharedInstance.strPendinfTripData = bookingID
        
        //            let alert = UIAlertController(title: nil, message: "Your trip is on there way.", preferredStyle: .alert)
        //            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
        //
        //                let myJobs = (self.navigationController?.childViewControllers[0] as! TabbarController).childViewControllers.last as! MyJobsViewController
        //
        //                myJobs.callSocket()
        //
        //                self.tabBarController?.selectedIndex = 0
        
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyJobsViewController") as? MyJobsViewController
        viewController?.callSocket()
//        Singletons.sharedInstance.isRequestAccepted = true // Bhavesh Changes
        self.webserviceofPendingJobs()
        
//        self.navigationController?.popViewController(animated: true)
        
        //            })
        //
        //            alert.addAction(OK)
        //
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
    }
    
}


