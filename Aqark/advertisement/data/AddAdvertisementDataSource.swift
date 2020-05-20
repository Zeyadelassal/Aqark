//
//  AddAdvertisementDataSource.swift
//  Aqark
//
//  Created by AhmedSaeed on 5/14/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation


import Firebase

class AddAdvertisementDataSource{
    
    var dataBaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var taskPerformace:StorageUploadTask!
    
    var advertisement: AddAdvertisementModel!
    
    var images : [String] = [String]()
    var address : [String : String] = [String : String]()
    var add : [String : Any] = [String : Any]()
    
    var advertisementAutoGeneratedName :String!
    var  userID : String!
    
    
    init(advertisement: AddAdvertisementModel) {
        self.advertisement = advertisement
        self.dataBaseRef = Database.database().reference()
        self.uploadAdvertisementData()
    }

    
    func uploadeImageToAdvertisement(completion : @escaping ()->Void){
        
        let meta = StorageMetadata.init()
        meta.contentType = "image/jpeg"
        
        for i in advertisement.images{
            
            let randomUUID = UUID.init().uuidString
            storageRef = Storage.storage().reference(withPath: "images/\(randomUUID).jpg")
            self.taskPerformace = self.storageRef.putData(i, metadata: meta) {[weak self] (metadata, error) in
                
                self!.findImageUrl {[weak self] (value, myError) in
                    if myError == nil{
                        self?.images.append(value!)
                        self?.setImagesUrl(url:value!)
                    }else{
                        // show alert cant fitch url
                        
                    }
                }
               
                
            }
        }
        completion()
    }
    
    
    func findImageUrl(comoletionValue : @escaping (String? , Error?)->Void){
        self.storageRef.downloadURL {(url, error) in
            guard let url = url else {return}
            comoletionValue("\(url)", error)
        }
    }
    
    var x = 1
    
    func setImagesUrl(url:String)  {
        print(x)
        self.dataBaseRef.child("Advertisements").child(advertisementAutoGeneratedName).child("images").setValue(images)
        
        
            
    }
    
    
    
    func uploadAdvertisementData(){
        
        userID = Auth.auth().currentUser?.uid
        advertisementAutoGeneratedName = dataBaseRef.childByAutoId().key!
    
        address = ["location": advertisement.location,
                    "latitude":advertisement.latitude,
                    "longitude": advertisement.longitude]
        
        add = [ "propertyType": advertisement.propertyType,
                "Advertisement Type": advertisement.advertisementType,
                "price" : advertisement.price,
                "bedRooms" : advertisement.bedrooms,
                "bathRooms" : advertisement.bathroom,
                "size" : advertisement.size,
                "phone" : advertisement.phone,
                "country": advertisement.country,
                "description": advertisement.description,
                "date" : advertisement.date,
                "Address" : address,
                "amenities" : advertisement.aminities,
                "UserId" : userID,
                "payment" : advertisement.payment]
        
        checkDataBeforUpload()
    }
    
    
    
    
    func checkDataBeforUpload (){

            dataBaseRef.child("Users_Ads_Free").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
                if let value = snapshot.value{
                    if value is NSNull
                    {
                        self.dataBaseRef.child("Users_Ads_Free").child(self.userID).setValue([self.advertisementAutoGeneratedName])
                        self.dataBaseRef.child("Advertisements").child(self.advertisementAutoGeneratedName!).setValue(self.add)
                        self.uploadeImageToAdvertisement {
                            print("stop indecator !!")
                        }
                        
                    }else{
                        var allFreeAds = value as! [NSString]
                
                        
                        if(allFreeAds.count < 4){
                            
                            allFreeAds.append(self.advertisementAutoGeneratedName! as NSString)
                            
                            self.dataBaseRef.child("Users_Ads_Free").child(self.userID).setValue(allFreeAds)
                            self.dataBaseRef.child("Advertisements").child(self.advertisementAutoGeneratedName!).setValue(self.add)
                            self.uploadeImageToAdvertisement {
                                print("stop indecator !!")
                            }

                        }else{
                            //payment alert
                            print(" you have only three show alert to tell him if you want to payment or no ")
                        }
                        
                    }
                   
                }
        
              }) { (error) in
                print(error.localizedDescription)
            }
            
    }
    

    
}