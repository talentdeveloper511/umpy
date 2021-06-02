//
//  VideoList.swift
//  UMPY
//
//  Created by CBDev on 4/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import Foundation
import ObjectMapper
class VideoList: Mappable{
    required init?(map: Map) {
        
    }
    var list:[VideoModel]?
    var status: Bool?
    func mapping(map: Map) {
        status <- map["status"]
        list <- map["data"]
    }
}
