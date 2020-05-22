//
//  AddAdvertisementViewController.swift
//  Aqark
//
//  Created by AhmedSaeed on 5/11/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit
import YPImagePicker
import GooglePlaces
import ReachabilitySwift


class AddAdvertisementViewController: UIViewController  {

    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var sizeTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var BedroomsTxtField: UITextField!
    @IBOutlet weak var BathroomTxtField: UITextField!
    @IBOutlet weak var countyTxtField: UITextField!
    
    @IBOutlet weak var describtionTxtView: UITextView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var networkIndicator = UIActivityIndicatorView()
    var config = YPImagePickerConfiguration()
    var addAdvertisementVM: AddAdvertisementViewModel!
    var activityIndicator:UIActivityIndicatorView!
   
    var selectAmenitiesDic:[Int: String] = [Int:String]()
    var pickerViewPropertyType:[String] = [String]()
    var advertisementType:String = "Rent"
    var propertyType:String = "Apartment"
    var selectedImages : [Data] = [Data]()
   
    var numberOfAdvertisementPerMonth:Int!
    
    var payment = "free"
    var latitude : String = ""
    var longitude : String = ""
    
    
    // autocomplete google sdk
    var autocompletecontroller = GMSAutocompleteViewController()
    var filter = GMSAutocompleteFilter()
    
    //MARK:- viewdidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCellOfCollectionView()
        collectionView.register(UINib(nibName: "AddAdvertisementsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "idAddAdvertisementsCollectionViewCell")
        
        
        //autocomplete delegation
        autocompletecontroller.delegate = self
        
        //stack view
        countryView.isHidden = true
        let screenSize: CGRect = UIScreen.main.bounds
        countryView.heightConstraint?.constant = screenSize.height;
        
        
        // picker view
        pickerViewPropertyType = ["Apartment" , "Villa" ,  "Room" ]
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        // add tapgestrure Regoginzer to imageview
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choosePhotos)))
        imageView.isUserInteractionEnabled = true
        
        // configtation of YPOmagePicker
        configtationYPOmagePicker()
        
        // setup textFeild under line
        setupTextFeildUnderLine()
        
        // setup image in letf textfield
        setupImageInLeftTextField()
        
        // setup button
        addButtonOutlet.layer.cornerRadius = 20
        
        //setup textview
        describtionTxtView.layer.borderWidth = 1
        describtionTxtView.layer.borderColor = UIColor.red.cgColor
        describtionTxtView.layer.cornerRadius = 12
     
    }
    
    //MARK:- view will Apper
    override func viewWillAppear(_ animated: Bool)
    {
        updatePlaceholderForPriceTextFeild()
    }
    
    // show view to select countries
    @IBAction func showCounties(_ sender: Any)
    {
        countryView.isHidden = false
        scrollView.isScrollEnabled = false
    }
    @IBAction func selectCountryAndHideStack(_ sender: UIButton) {
        countryView.isHidden = true
        countyTxtField.text = sender.titleLabel?.text
        priceTxtField.becomeFirstResponder() // used to jump to next text feild
        scrollView.isScrollEnabled = true
    }
    
    
    // select address to open google autocomplete
    @IBAction func addAutoCompleteAddress(_ sender: Any) {

        filter.type = .address  //suitable filter type
        filter.country = "eg"  //appropriate country code
        autocompletecontroller.autocompleteFilter = filter
        addressTxtField.resignFirstResponder()
        present(autocompletecontroller, animated: true, completion: nil)
    }
    
    
    @IBAction func increaseBedRoomNumber(_ sender: UIStepper) {
        self.BedroomsTxtField.text = String(Int(sender.value))
    }
    
    @IBAction func increaseBathRoomNumber(_ sender: UIStepper) {
         self.BathroomTxtField.text = String(Int(sender.value))
    }
    //MARK: - func SaveButton
    
    @IBAction func saveAdvertisement(_ sender: Any) {
        
        
        addAdvertisementVM = AddAdvertisementViewModel(payment:self.payment,
                                                       propertyType: self.propertyType,
                                                       advertisementType: self.advertisementType,
                                                       price: self.priceTxtField.text!,
                                                       bedrooms: self.BedroomsTxtField.text!,
                                                       bathroom: self.BathroomTxtField.text!,
                                                       size: self.sizeTxtField.text!,
                                                       phone: self.phoneTxtField.text!,
                                                       location: self.addressTxtField.text!,
                                                       latitude: self.latitude,
                                                       longitude: self.longitude,
                                                       country: self.countyTxtField.text!,
                                                       description: self.describtionTxtView.text!,
                                                       aminities: self.selectAmenitiesDic,
                                                       images: self.selectedImages)
        
        
        if addAdvertisementVM.isValid == false{
            
            let alertValues = addAdvertisementVM.borkenRule[0]
            alertControllerMessage(title: alertValues.brokenType, message: alertValues.message)
            
        }else{
            
            //check rechability
            if checkNetworkConnection(){
                
                if switchButton.isOn{
                    
                    //start indecator
                    showIndicator()
                    
                    // upload advertisements
                    addAdvertisementVM.save()
                    
                    //stop indecator
                    
                    
                    
                }else{
                    //navigate to payment viewcontroller
                    print("navegaion")
                }
                
                
            }else{
                alertControllerMessage(title: "no Internet Connection", message: "please check for internet connnectoin")
            }
        }
      
    }

  
    
     //MARK: - func indicator show and hide
        
    func stopIndicator() {
        networkIndicator.stopAnimating()
    }
    
    func showIndicator()
    {
        networkIndicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        networkIndicator.center = view.center
        networkIndicator.startAnimating()
        view.addSubview(networkIndicator)
    }

    
    //MARK: - func to chekc internet connection rechablity
    
    func checkNetworkConnection()->Bool
    {
        let connection = Reachability()
        guard let status = connection?.isReachable else{return false}
        return status
    }
    
   
    
    //MARK:-func configtation of YPOmagePicker
    
    func configtationYPOmagePicker(){
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
       // config.showsPhotoFilters = true
       // config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
       // config.maxCameraZoomFactor = 1.0
        config.library.maxNumberOfItems = 5
        config.library.minNumberOfItems = 1
        
    }
    
    
    //MARK:- func setup textFeild under line
    
    func setupTextFeildUnderLine(){
//        priceTxtField.delegate = self
//        sizeTxtField.delegate = self
//        addressTxtField.delegate = self
//        phoneTxtField.delegate = self
//        BedroomsTxtField.delegate = self
//        BathroomTxtField.delegate = self
//        countyTxtField.delegate = self
        
        priceTxtField.setUnderLine()
        phoneTxtField.setUnderLine()
        sizeTxtField.setUnderLine()
        addressTxtField.setUnderLine()
        phoneTxtField.setUnderLine()
        BedroomsTxtField.setUnderLine()
        BathroomTxtField.setUnderLine()
        countyTxtField.setUnderLine()
        
    }
   
    
    //MARK:- func setup image in letf textfield
    
    func setupImageInLeftTextField(){
        priceTxtField.setIcon(UIImage(named: "Advertisement_ic_monetization_on_24px.pdf")!)


        phoneTxtField.setIcon(UIImage(named: "Advertisement_flag.pdf")!)

        sizeTxtField.setIcon(UIImage(named:"Advertisement_house-size_2.pdf")!)
        addressTxtField.setIcon(UIImage(named: "Advertisement_Mask Group 22.pdf")!)
        BedroomsTxtField.setIcon(UIImage(named: "Advertisement_bed.pdf")!)
        BathroomTxtField.setIcon(UIImage(named: "Advertisement_Bathtub-bathroom-hotel-cleaning.pdf")!)
        countyTxtField.setIcon(UIImage(named: "Advertisement_flag.pdf")!)
    }
    
    
    //MARK: - func select Amenities value when you check boxs
    
    @IBAction func selectAmenities(_ sender: UIButton) {

        if let myButtonImage = sender.currentImage, let buttonAppuyerImage = UIImage(named: "advertisement_uncheck.png"), myButtonImage.pngData() == buttonAppuyerImage.pngData()
        {
            sender.setImage(UIImage(named: "advertisement_check"), for: .normal)
            selectAmenitiesDic[sender.tag] = selectAmenitiesValue(tagNumber: sender.tag)
        }else{
            sender.setImage(UIImage(named: "advertisement_uncheck"), for: .normal)
            selectAmenitiesDic.removeValue(forKey: sender.tag)
        }
  
    }
    
    func selectAmenitiesValue(tagNumber : Int)-> String{
        var value:String = ""
        switch tagNumber {
        case 0:
            value = "Furnished"
        case 1:
            value = "Shared Spa"
        case 2:
            value = "Central A/C"
        case 3:
            value = "Maids Room"
        case 4:
            value = "Security"
        case 5:
            value = "Kitchen Appliances"
        case 6:
            value = "Networked"
        case 7:
            value = "Covered Parking"
        case 8:
            value = "Pets Allowed"
        case 9:
            value = "Barbecue Area"
        case 10:
            value = "Balcony"
        case 11:
            value = "Walk-in Closet"
        case 12:
            value = "Study"
        case 13:
            value = "Private garden"
        case 14:
            value = "Children's Play Area"
        default:
            print("switch problem")
        }
        return value
    }
    
    
    //MARK:- func to Config segment
    
    @IBAction func selectAdvertisementType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            advertisementType = "Rent"
        case 1:
            advertisementType = "Buy"
        default:
            print("error")
        }
        
        updatePlaceholderForPriceTextFeild()
    }
    
    
    func updatePlaceholderForPriceTextFeild(){
        
        if advertisementType == "Rent"
        {
            switch propertyType {
                case "Apartment":
                    priceTxtField.placeholder = "minimum price is 500$"
                case "Villa":
                    priceTxtField.placeholder = "minimum price is 5000$"
                case "Room":
                    priceTxtField.placeholder = "minimum price is 200$ "
                default:
                    print("noselection")
            }
            
        }else{
            switch propertyType {
                case "Apartment":
                    priceTxtField.placeholder = "minimum price is 50,000$ "
                case "Villa":
                    priceTxtField.placeholder = "minimum price is 500,000$ "
                case "Room":
                    priceTxtField.placeholder = "minimum price is 10,000$ "
                
                default:
                    print("noselection")
            }
            
        }
    }
    //MARK:- alertMessage
    func alertControllerMessage(title: String , message : String){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:- switch toggle function
    @IBAction func switchToggle(_ sender: UISwitch) {
        
        if sender.isOn {
            self.payment = "free"
        }else{
            self.payment = "premium"
        }
        
    }
    
    
}




//MARK: - configraiton for textField taps

//extension AddAdvertisementViewController : UITextFieldDelegate{
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("Start")
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("end")
//    }
//}
