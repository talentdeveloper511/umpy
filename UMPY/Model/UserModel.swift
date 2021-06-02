//
//  UserModel.swift
//  UMPY
//
//  Created by CBDev on 4/2/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import Foundation
import ObjectMapper
class UserModel : Mappable{
    required init?(map: Map) {
        
    }
    var id:String?
    var firstName:String?
    var secName:String?
    var email:String?
    var country: String?
    var home_city:String?
    var phoneNum: String?
    var password: String?
    var user_type: String?
    var latitude: String?
    var longitude:String?
    var status: Bool?
    
    func mapping(map: Map) {
        id              <- map["user_data.id"]
        firstName            <- map["user_data.first_name"]
        secName          <- map["user_data.sec_name"]
        email          <- map["user_data.email"]
        country        <- map["user_data.country"]
        home_city           <- map["user_data.home_city"]
        phoneNum              <- map["user_data.phone_num"]
        password            <- map["user_data.password"]
        user_type          <- map["user_data.user_type"]
        latitude            <- map["user_data.latitude"]
        longitude          <- map["user_data.longitude"]
        status          <- map["status"]
    }
}
