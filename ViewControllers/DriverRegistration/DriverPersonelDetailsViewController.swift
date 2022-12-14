//
//  DriverPersonelDetailsViewController.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 11/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import CoreLocation
class DriverPersonelDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate  {
    
    @IBOutlet var btnNext: UIButton!
    
    let manager = CLLocationManager()
    
    var currentLocation = CLLocation()
    
    var strLatitude = Double()
    var strLongitude = Double()
    
    var userDefault =  UserDefaults.standard
    
     let datePicker = UIDatePicker()
    var companyID = String()
     var emailID = String()
    var aryCompanyIDS = [[String:AnyObject]]()
//        let myDatePicker: UIDatePicker = UIDatePicker()

    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var btnOthers: UIButton!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
   
    @IBOutlet weak var txtInviteCode: UITextField!

    @IBOutlet weak var constraintHeightOfAllTextFields: NSLayoutConstraint! // 45
    @IBOutlet weak var constraintHeightOfProfileImage: NSLayoutConstraint! // 75
    
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var lblHaveAnAccount: UILabel!
    @IBOutlet weak var bntLogin: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetLocalizable()
    }
    
    func SetLocalizable()
    {
        self.title = "App Name".localized

        txtFullName.placeholder = "User Name".localized
        txtAddress.placeholder = "Address".localized
        lblMale.text = "Male".localized
        lblFemale.text = "Female".localized
        txtInviteCode.placeholder = "Invite Code (Optional)".localized
        btnNext.setTitle("Next".localized, for: .normal)
    }
   

    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.masksToBounds = true
        btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        btnNext.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPAD {
            constraintHeightOfAllTextFields.constant = 35
            constraintHeightOfProfileImage.constant = 55
        }
        
        showDatePicker()
        txtDOB.delegate = self
        txtPostCode.delegate = self


        
        strLatitude = 0
        strLongitude = 0
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
            {
                if manager.location != nil
                {
                    currentLocation = manager.location!
                    manager.delegate = self
                    strLatitude = currentLocation.coordinate.latitude
                    strLongitude = currentLocation.coordinate.longitude
                }
                
                manager.startUpdatingLocation()
            }
        }
        
        
        btnMale.setImage((UIImage(named: "iconRadioSelected")?.withRenderingMode(.alwaysTemplate)), for: .selected)
        btnMale.setImage((UIImage(named: "iconRadioUnSelected")?.withRenderingMode(.alwaysTemplate)), for: .normal)
        btnFemale.setImage((UIImage(named: "iconRadioSelected")?.withRenderingMode(.alwaysTemplate)), for: .selected)
        btnFemale.setImage((UIImage(named: "iconRadioUnSelected")?.withRenderingMode(.alwaysTemplate)), for: .normal)
        
        
        selectedMale()
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItem.Style.bordered, target: self, action: #selector(donedatePicker))//"donedatePicker"
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: UIBarButtonItem.Style.bordered, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtDOB.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDOB.inputView = datePicker
        
    }
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDOB.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker()
    {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
 
    @IBAction func btnMale(_ sender: UIButton) {
        selectedMale()
    }
    @IBAction func btnFemale(_ sender: UIButton) {
        selectedFemale()
    }
//    @IBAction func btnOthers(_ sender: UIButton) {
//        selectedOthers()
//    }
    
    
    func selectedMale()
    {
        btnMale.isSelected = true
        btnMale.tintColor = ThemeYellowColor
        btnFemale.isSelected = false
        btnFemale.tintColor = UIColor.white
//        btnOthers.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
    }
    func selectedFemale()
    {
        btnFemale.isSelected = true
        btnFemale.tintColor = ThemeYellowColor
        btnMale.isSelected = false
        btnMale.tintColor = UIColor.white
        
//        btnOthers.setImage(UIImage(named: "iconCheckMarkUnSelected"), for: .normal)
    }
//    func selectedOthers()
//    {
//        btnMale.setImage(UIImage(named: "iconRadioUnSelected"), for: .normal)
//        btnFemale.setImage(UIImage(named: "iconRadioUnSelected"), for: .normal)
////        btnOthers.setImage(UIImage(named: "iconCheckMarkSelected"), for: .normal)
//    }
    
    @IBAction func btnNext(_ sender: Any)
    {
        let validator = checkFields()
        if validator.0 == true {
            setData()
        } else {
            let ValidationAlert = UIAlertController(title: "App Name".localized, message: validator.1, preferredStyle: UIAlertController.Style.alert)
            ValidationAlert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler: nil))
            self.present(ValidationAlert, animated: true, completion: nil)
        }
    }
    @IBAction func btnLogin(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func TapToProfilePicture(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Choose Photo".localized, message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Select photo from gallery".localized
, style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
        let Camera  = UIAlertAction(title: "Select photo from camera".localized
, style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func PickingImageFromGallery()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // picker.stopVideoCapture()
        picker.mediaTypes = [kUTTypeImage as String]
//            UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        
        present(picker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveAllDataInArray() -> NSMutableArray {
        
        let arrData = NSMutableArray()
        let dictData = NSMutableDictionary()
        
            dictData.setObject(txtFullName.text!, forKey: RegistrationProfileKeys.kKeyFullName as NSCopying)
            dictData.setObject(txtDOB.text!, forKey: RegistrationProfileKeys.kKeyDOB as NSCopying)
            dictData.setObject(txtAddress.text!, forKey: RegistrationProfileKeys.kKeyAddress as NSCopying)
            dictData.setObject(txtPostCode.text!, forKey: RegistrationProfileKeys.kKeyPostCode as NSCopying)
            dictData.setObject(txtInviteCode.text!, forKey: RegistrationProfileKeys.kKeyInviteCode as NSCopying)
           dictData.setObject(imgProfile.image!.pngData()! as NSData, forKey: RegistrationFinalKeys.kDriverImage as NSCopying)
            
            arrData.add(dictData)
        
        
        return arrData
  
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location: CLLocation = locations.last!
        strLatitude = location.coordinate.latitude
        strLongitude = location.coordinate.longitude
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
        
    }
    
    func checkFields() -> (Bool,String)
    {
        var isValidate:Bool = true
        var ValidatorMessage:String = ""
        
//        let sb = Snackbar()
//        sb.createWithAction(text: "Upload Car Registration", actionTitle: "Dismiss".localized, action: { print("Button is push") })

        if txtFullName.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValidate = false
            ValidatorMessage = "Please enter user name".localized
//            sb.createWithAction(text: "Please enter user name".localized, actionTitle: "Dismiss".localized, action: { print("Button is push") })
        }
//        else if txtDOB.text == "" {
//            sb.createWithAction(text: "Enter Date of Birth", actionTitle: "Dismiss".localized, action: { print("Button is push") })
//        }
        else if txtAddress.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            isValidate = false
            ValidatorMessage = "Please enter address".localized
//             sb.createWithAction(text: , actionTitle: "Dismiss".localized, action: { print("Button is push") })
        }
      
//        else if txtPostCode.text == "" {
//            sb.createWithAction(text: "Enter Post Code", actionTitle: "Dismiss".localized, action: { print("Button is push") })
//        }
      
        else if imgProfile.image == UIImage(named: "iconProfileLocation") {
            isValidate = false
            ValidatorMessage = "Choose Photo".localized
//            sb.createWithAction(text: "Choose Photo".localized, actionTitle: "Dismiss".localized, action: { print("Button is push") })
        }
       
        
//        sb.show()
        return (isValidate,ValidatorMessage)
    }
    
    func setDataForProfile()
    {
//        txtEmail.text = userDefault.object(forKey: RegistrationFinalKeys.kEmail) as? String
//        aryCompanyIDS = userDefault.object(forKey: OTPCodeStruct.kCompanyList) as! [[String : AnyObject]]
//        thePicker.reloadAllComponents()
//
//
//        txtCompanyId.text = aryCompanyIDS[0]["CompanyName"] as? String
//        companyID = (aryCompanyIDS[0]["Id"] as? String)!
//        txtCity.text = aryCompanyIDS[0]["City"] as? String
//        txtState.text = aryCompanyIDS[0]["State"] as? String
//        txtCountry.text = aryCompanyIDS[0]["Country"] as? String
    }
    
    func setData()
    {
       
        
        let imageData: NSData = imgProfile.image!.pngData()! as NSData
        let myEncodedImageData: NSData = NSKeyedArchiver.archivedData(withRootObject: imageData) as NSData
        userDefault.set(myEncodedImageData, forKey: RegistrationFinalKeys.kDriverImage)
        
        let image = UIImage(data: imageData as Data)
        imgProfile.image = image
        
        userDefault.set(txtDOB.text, forKey: RegistrationFinalKeys.kKeyDOB)
        userDefault.set(txtFullName.text, forKey: RegistrationFinalKeys.kFullname)
        userDefault.set(txtAddress.text, forKey: RegistrationFinalKeys.kAddress)
        userDefault.set(txtInviteCode.text, forKey: RegistrationFinalKeys.kReferralCode)
        userDefault.set(strLatitude, forKey: RegistrationFinalKeys.kLat)
        userDefault.set(strLongitude, forKey: RegistrationFinalKeys.kLng)
        userDefault.set(txtPostCode.text, forKey: RegistrationFinalKeys.kZipcode)

        
        if btnMale.isSelected {
            userDefault.set("Male", forKey: RegistrationFinalKeys.kGender)
        }
        else if btnFemale.isSelected {
            userDefault.set("Female", forKey: RegistrationFinalKeys.kGender)
        }
//        else if (btnOthers.currentImage?.isEqual(UIImage(named: "iconRadioSelected")))! {
//            userDefault.set("Other", forKey: RegistrationFinalKeys.kGender)
//        }
        else {
            userDefault.set("Male", forKey: RegistrationFinalKeys.kGender)
        }


        navigateToNext()
    }
  
    func navigateToNext()
    {
         UserDefaults.standard.set(2, forKey: savedDataForRegistration.kPageNumber)
        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
        let x = self.view.frame.size.width * 2
        driverVC.scrollObj.setContentOffset(CGPoint(x:x, y:0), animated: true)
        driverVC.viewTwo.backgroundColor = ThemeYellowColor
//        let driverVC = self.navigationController?.viewControllers.last as! DriverRegistrationViewController
        driverVC.viewDidLayoutSubviews()
//        driverVC.imgBank.image = UIImage.init(named: iconBankSelect)
        if (self.saveAllDataInArray().count != 0)
        {
            UserDefaults.standard.set(self.saveAllDataInArray(), forKey: savedDataForRegistration.kKeyAllUserDetails)
        }
       
    }
    
    // For Mobile Number
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
     
         if textField == txtPostCode {
            let resText: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)

            if resText!.count >= 9 {
                return false
            }
            else {
                return true
            }
        }
        
        return true
    }
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
//        if textField == txtDOB
//        {
//            self.view.endEditing(true)
//            Calendar()
//            return false
//        }
        
        return true
    }
    

    func Calendar()
    {
        // make DatePicker
        
        
        // setting properties of the datePicker
//        myDatePicker.frame = CGRect(x:0, y: 50,width: self.view.frame.width, height: 200)
//        myDatePicker.timeZone = NSTimeZone.local
//        myDatePicker.backgroundColor = UIColor.white
//        myDatePicker.layer.cornerRadius = 5.0
//        myDatePicker.layer.shadowOpacity = 0.5
//        myDatePicker.datePickerMode = .date
//        // add an event called when value is changed.
//        myDatePicker.addTarget(self, action: #selector(self.onDidChangeDate(sender:)), for: .valueChanged)
//
//        // add DataPicker to the view
//        self.view.addSubview(myDatePicker)
    }
    
    // called when the date picker called.
    internal func onDidChangeDate(sender: UIDatePicker){
        
        // date format
//        let myDateFormatter: DateFormatter = DateFormatter()
//        myDateFormatter.dateFormat = "yyyy/MM/dd"
//        
//        // get the date string applied date format
//        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
//        txtDOB.text = mySelectedDate as String
//        
//        self.myDatePicker.removeFromSuperview()
    }
    
}
