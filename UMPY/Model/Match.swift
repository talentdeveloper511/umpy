//
//  Match.swift
//  UMPY
//
//  Created by CBDev on 4/3/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import Foundation
import ObjectMapper

class Match: Mappable{
    var home_team: String?
    var visitors: String?
    var venue: String?
    var grade: String?
    var id: String?
    var date: String?
    var user_id: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        home_team <- map["home_team"]
        visitors <- map["visitors"]
        venue <- map["venue"]
        grade <- map["grade"]
        date <- map["date"]
        user_id <- map["user_id"]        
    }
}
