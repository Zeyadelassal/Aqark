//
//  AdminAdvertisementsViewController.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 5/16/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import UIKit

class AdminAdvertisementsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var advertisementsCollectionView: UICollectionView!
    @IBOutlet weak var advertisementsSearchBar: UISearchBar!
    
    private var adminAdvertisementViewModel : AdminAdvertisementsListViewModel!
    private var dataAccess : AdminDataAccess!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataAccess = AdminDataAccess()
        adminAdvertisementViewModel = AdminAdvertisementsListViewModel(dataAccess:dataAccess)
        self.navigationItem.title = "Advertisements"
        if(adminAdvertisementViewModel.checkNetworkConnection()){
            activityIndicator.startAnimating()
            self.view.alpha = 0
            advertisementsCollectionView.register(UINib(nibName: "AdminAdvertisementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Advertisement Cell")
            advertisementsCollectionView.delegate = self
            advertisementsCollectionView.dataSource = self
            advertisementsSearchBar.delegate = self
            adminAdvertisementViewModel.populateAdvertisements {
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration:2) {
                    self.view.alpha = 1
                }
                if(self.adminAdvertisementViewModel.adminAdvertisementsViewList.isEmpty){
                    self.setLabelForZeroCount()
                }
                self.advertisementsCollectionView.reloadData()
            }
        }else{
            noLabel.isHidden = false
            noLabel.text = "No Internet Connection."
        }
        
    }
    
    private func setLabelForZeroCount(){
        noLabel.isHidden = false
        noLabel.text = "No Available Advertisements"
    }
}

extension AdminAdvertisementsViewController : UICollectionViewDelegate,UICollectionViewDataSource,AdminAdvertisementsCollectionDelegate{
    
    func removeAdvertisementDelegate(at indexPath: IndexPath) {
        showAlert { (result) in
            if(result){
                self.advertisementsCollectionView.performBatchUpdates({
                    self.adminAdvertisementViewModel.deleteAdvertisement(adminAdvertisement: self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row])
                    self.adminAdvertisementViewModel.adminAdvertisementsViewList.remove(at: indexPath
                        .row)
                    self.advertisementsCollectionView.deleteItems(at: [indexPath])
                }) { (finished) in
                    self.advertisementsCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.adminAdvertisementViewModel.adminAdvertisementsViewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let advertisementCell = advertisementsCollectionView.dequeueReusableCell(withReuseIdentifier: "Advertisement Cell", for: indexPath) as! AdminAdvertisementCollectionViewCell
        advertisementCell.adminAdvertisementsCollectionDelegate = self
        advertisementCell.adminAdvertisementsCellIndex = indexPath
        advertisementCell.advertisementPropertyType.text = self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertyType
        advertisementCell.advertisementPropertyPrice.text = self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertyPrice
        advertisementCell.advertisementPropertyAddress.text = self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertyAddress
        advertisementCell.advertisementPropertySize.text = self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertySize
        advertisementCell.advertisementPropertyBedNumbers.text = self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertyBedsNumber
        advertisementCell.advertisementPropertyBathRoomNumbers.text = self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertyBathRoomsNumber
        let advertisementPropertyImageURL = URL(string:self.adminAdvertisementViewModel.adminAdvertisementsViewList[indexPath.row].advertisementPropertyImages[0])
        advertisementCell.advertisementPropertyImage.sd_setImage(with:advertisementPropertyImageURL , placeholderImage: UIImage(named: "signup_company"))
        return advertisementCell
    }
    
    private func showAlert(completion:@escaping(Bool)->Void)
    {
        let alert:UIAlertController = UIAlertController(title: "Delete Adverisement", message: "Are You Sure You Want To Delete This Advertisement ?", preferredStyle: .actionSheet)
        let delete:UIAlertAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            completion(true)
        }
        let cancel:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true)
            completion(false)
        }
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

extension AdminAdvertisementsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30 , height: collectionView.frame.height/3);
    }
}


extension AdminAdvertisementsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        adminAdvertisementViewModel.getFilteredAdvertisements(searchText: searchText)
        advertisementsCollectionView.reloadData()
    }
}


