//
//  extensionSetupView.swift
//  Aqark
//
//  Created by AhmedSaeed on 5/27/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation
import  UIKit

extension AddAdvertisementViewController{
     func setupView(){
         self.view.backgroundColor = UIColor(rgb: 0xf1faee)
         self.myView.backgroundColor = UIColor(rgb: 0xf1faee)
         self.navigationItem.title = "Add Advertisement".localize
         self.segment.tintColor = UIColor(rgb: 0x1d3557)
         self.bedRoomStepper.tintColor = UIColor(rgb: 0x1d3557)
         self.bathRoomStepper.tintColor = UIColor(rgb: 0x1d3557)
         self.descriptionTitle.textColor = UIColor(rgb: 0x457b9d)
         self.amenitiesTitle.textColor = UIColor(rgb: 0x457b9d)
         self.collectionView.backgroundColor = UIColor(rgb: 0xf1faee)
         blackIndicatorView.isHidden = true
        
        describtionTxtView.layer.borderWidth = 1
        describtionTxtView.layer.borderColor = UIColor(rgb: 0x1d3557).cgColor
        describtionTxtView.layer.cornerRadius = 10
        
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCellOfCollectionView()
        collectionView.register(UINib(nibName: "AddAdvertisementsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "idAddAdvertisementsCollectionViewCell")
        
        priceTxtField.delegate = self
        sizeTxtField.delegate = self
        addressTxtField.delegate = self
        phoneTxtField.delegate = self
        BedroomsTxtField.delegate = self
        BathroomTxtField.delegate = self
        countryTxtFieldSearch.delegate = self
        self.makeTappedGesture()
     
     
        autocompletecontroller?.delegate = self
     
        pickerViewPropertyType = ["Apartment" , "Villa" ,  "Room" ]
        pickerView.delegate = self
        pickerView.dataSource = self
         
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choosePhotos)))
        imageView.isUserInteractionEnabled = true
        
        configtationYPOmagePicker()
        
        setupImageInLeftTextField()
        
        countries = Countries()
        countryTxtFieldSearch.filterStrings(countries.countries)
        countryTxtFieldSearch.maxNumberOfResults = 10
        countryTxtFieldSearch.maxResultsListHeight = 200
        countryTxtFieldSearch.theme.font = UIFont.systemFont(ofSize: 12)
        countryTxtFieldSearch.theme.bgColor = UIColor (red: 12, green: 4, blue: 4, alpha: 0.7)
        countryTxtFieldSearch.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        countryTxtFieldSearch.theme.separatorColor = UIColor (red: 4, green: 4, blue: 4, alpha: 0.7)
  
     }
    
    @IBAction func showCountryMenue(_ sender: Any) {
           countryTxtFieldSearch.startVisibleWithoutInteraction = true
       }
    
    func makeTappedGesture()
    {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.makeDissmissKeyboard))
        self.myView.isUserInteractionEnabled = true
        self.myView.addGestureRecognizer(tap)
    }
    @objc func makeDissmissKeyboard(){
        myView.endEditing(true)
    }
    
    //MARK:- alertMessage
    func alertControllerMessage(title: String , message : String ){
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Ok".localize, style: .default, handler: nil)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupImageInLeftTextField(){
        priceTxtField.setIcon(UIImage(named: "money")!)
        phoneTxtField.setIcon(UIImage(named: "phone")!)
        sizeTxtField.setIcon(UIImage(named:"ad_size")!)
        addressTxtField.setIcon(UIImage(named: "profile_map")!)
        BedroomsTxtField.setIcon(UIImage(named: "ad_bed")!)
        BathroomTxtField.setIcon(UIImage(named: "ad_bath")!)
        countryTxtFieldSearch.setIcon(UIImage(named: "country")!)
    }
}


extension AddAdvertisementViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

