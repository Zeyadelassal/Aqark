//
//  AdminAdvertisementsListViewModelTests.swift
//  AqarkTests
//
//  Created by ZeyadEl3ssal on 6/7/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import XCTest
@testable import Aqark

class AdminAdvertisementsListViewModelTests: XCTestCase {
    
    var dataAccess : AdminDataAccess!
    var adminAdvertisementsViewModel : AdminAdvertisementsListViewModel!
    
    override func setUp(){
        dataAccess = AdminDataAccess()
        adminAdvertisementsViewModel = AdminAdvertisementsListViewModel(dataAccess: dataAccess)
    }
    
    override func tearDown() {
        dataAccess = nil
        adminAdvertisementsViewModel = nil
    }
    
//    func testGetFilteredAdvertisements(){
//
//        createAdvertisments()
//        
//        adminAdvertisementsViewModel.getFilteredAdvertisementsByType(searchText: "C")
//        XCTAssertEqual(adminAdvertisementsViewModel.adminAdvertisementsViewList.count, 1)
//        
//        adminAdvertisementsViewModel.getFilteredAdvertisementsByType(searchText: "M")
//        XCTAssertEqual(adminAdvertisementsViewModel.adminAdvertisementsViewList.count, 1)
//        
//        adminAdvertisementsViewModel.getFilteredAdvertisementsByType(searchText: "Z")
//        XCTAssertEqual(adminAdvertisementsViewModel.adminAdvertisementsViewList.count, 0)
//        
//        adminAdvertisementsViewModel.getFilteredAdvertisementsByType(searchText: "")
//        XCTAssertEqual(adminAdvertisementsViewModel.adminAdvertisementsViewList.count, 2)
//    }
//    
//    func createAdvertisments(){
//        let advertisement1 = AdminAdvertisement(advertisementId: "112233", advertisementPropertyLatitude: "31.76", advertisementPropertyLongitude: "33.11", advertisementPropertyLocation: "Mansoura", advertisementType: "Rent", advertisemetentUserId: "123", advertisementPropertyAmenities: [""], advertisementPropertyBathRooms: "1", advertisementPropertyBeds: "1", advertisementCountry: "Mansoura", advertisementDate: "2020", advertisementPropertyDescription: "Nice", advertismentsPropertyImages: [""], advertisementPaymentType: "Free", adevertisementPhone: "111", advertisementPropertyPrice: "150", advertisementPropertyType: "Room", advertisementPropertySize: "100")
//        let advertisement2 = AdminAdvertisement(advertisementId: "445566", advertisementPropertyLatitude: "31.76", advertisementPropertyLongitude: "33.11", advertisementPropertyLocation: "Cairo", advertisementType: "Rent", advertisemetentUserId: "123", advertisementPropertyAmenities: [""], advertisementPropertyBathRooms: "1", advertisementPropertyBeds: "1", advertisementCountry: "Cairo", advertisementDate: "2020", advertisementPropertyDescription: "Nice", advertismentsPropertyImages: [""], advertisementPaymentType: "Free", adevertisementPhone: "111", advertisementPropertyPrice: "150", advertisementPropertyType: "Room", advertisementPropertySize: "100")
//        let advertisementModel1 = AdminAdvertisementViewModel(adminAdvertisment: advertisement1)
//        let advertisementModel2 = AdminAdvertisementViewModel(adminAdvertisment: advertisement2)
//        adminAdvertisementsViewModel.adminAdvertisementsList.append(advertisementModel1)
//        adminAdvertisementsViewModel.adminAdvertisementsList.append(advertisementModel2)
//    }
}

