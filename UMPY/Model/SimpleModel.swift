//
//  SimpleModel.swift
//  UMPY
//
//  Created by CBDev on 4/3/19.
//  Copyright © 2019 CBDev. All rights reserved.
//
import Foundation
import ObjectMapper
class SimpleModel : Mappable{
    required init?(map: Map) {
        
    }
    var status: Bool?
    var data: String?
    func mapping(map: Map) {
        status        <- map["status"]
        data          <- map["data"]
    }
}
