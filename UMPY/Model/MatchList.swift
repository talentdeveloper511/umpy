//
//  MatchList.swift
//  UMPY
//
//  Created by CBDev on 4/3/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import Foundation
import ObjectMapper
class MatchList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[Match]?
    var status: Bool?
    func mapping(map: Map) {
        status <- map["status"]
        list <- map["data"]
    }
}
