//
//  ServiceUserViewModel.swift
//  Aqark
//
//  Created by ZeyadEl3ssal on 5/28/20.
//  Copyright © 2020 ITI. All rights reserved.
//

import Foundation

class ServiceUserViewModel{
    var serviceUserId : String = ""
    var serviceUserName : String = ""
    var serviceUserCountry : String = ""
    var serviceUserServiceRating : Double = 0.0
    var serviceUserExperience : String = ""
    var serviceUserCompany : String = ""
    var ServiceUserImage : String = ""
    
    init(serviceUser : ServiceUser) {
        self.serviceUserId = serviceUser.userId
        self.serviceUserName = serviceUser.userName
        self.serviceUserCountry  = serviceUser.userCountry
        self.serviceUserServiceRating = serviceUser.userServiceRating
        self.serviceUserExperience = serviceUser.userExperience + " years exp"
        self.serviceUserCompany = serviceUser.userCompany + " company"
        self.ServiceUserImage = serviceUser.userImage
    }
}
