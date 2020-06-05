//
//  ServicesCollectionViewCell.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 5/28/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit
import Cosmos

class ServicesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var serviceUserImage: UIImageView!
    @IBOutlet weak var serviceUserName: UILabel!
    @IBOutlet weak var serviceUserCompany: UILabel!
    @IBOutlet weak var serviceUserLocation: UILabel!
    @IBOutlet weak var serviceUserExperience: UILabel!
    @IBOutlet weak var serviceUserRating: CosmosView!
    @IBOutlet weak var rateMeView: CosmosView!
    @IBOutlet weak var rateMeButton: UIButton!
    @IBOutlet weak var dialerButton: UIButton!
    @IBOutlet var dialerButtonTrailingConstraint: NSLayoutConstraint!
    
    var serviceUserCellIndex : IndexPath!
    var serviceUserDelegate : ServiceUsersCollectionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serviceUserRating.settings.fillMode = .precise
        rateMeView.settings.fillMode = .precise
        rateMeView.didFinishTouchingCosmos = {rating in
            self.rateMeButton.alpha = 0
            self.rateMeButton.isHidden = false
            print(rating)
            UIView.animate(withDuration: 0.6, animations: {
                self.rateMeView.alpha = 0
                self.rateMeButton.alpha = 1
            }) { (finished) in
                self.rateMeView.isHidden = finished
                 self.serviceUserDelegate.rateServiceUserDelegate(at: self.serviceUserCellIndex,rate:rating)
            }
        }
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        if(serviceUserDelegate.checkLoggedUserDelegate()){
                  rateMeButton.isHidden = false
                  dialerButtonTrailingConstraint.isActive = true
                  dialerButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = false
              }else{
                  rateMeButton.isHidden = true
                  dialerButtonTrailingConstraint.isActive = false
                  dialerButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
              }
        if(serviceUserCompany.text == " company"){
            detailsStackView.removeArrangedSubview(serviceUserCompany)
            serviceUserCompany.removeFromSuperview()
        }
        if(serviceUserExperience.text == "Not Provided years exp"){
            detailsStackView.removeArrangedSubview(serviceUserExperience)
            serviceUserExperience.removeFromSuperview()
        }
    }
    
    @IBAction func rateServiceUser(_ sender: Any) {
        let sameUser = serviceUserDelegate.checkServiceUserDelegate(at:serviceUserCellIndex)
        if(!sameUser){
            self.rateMeView.alpha = 0
            self.rateMeView.isHidden = false
            UIView.animate(withDuration: 0.6, animations: {
                self.rateMeButton.alpha = 0
                self.rateMeView.alpha = 1
            }) { (finished) in
                self.rateMeButton.isHidden = finished
            }
        }
    }
}