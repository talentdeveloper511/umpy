//
//  VideoModel.swift
//  UMPY
//
//  Created by CBDev on 4/11/19.
//  Copyright © 2019 CBDev. All rights reserved.
//


import Foundation
import ObjectMapper

class VideoModel: Mappable{
    var id: String?
    var match_id: String?
    var video_url: String?
    var permission: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        match_id <- map["match_id"]
        video_url <- map["video_url"]
        permission <- map["permission"]
    }
}
