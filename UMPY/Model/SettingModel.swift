//
//  SettingModel.swift
//  UMPY
//
//  Created by CBDev on 4/9/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingModel: Mappable{
    var videoResolution: String?
    var enableAudio: String?
    var videoPermission: String?
    var videoDuration: String?
    var id: String?
    var user_id: String?
    var status: Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["data.id"]
        videoResolution <- map["data.video_resolution"]
        enableAudio <- map["data.enable_audio"]
        videoPermission <- map["data.video_permission"]
        videoDuration <- map["data.video_duration"]
        user_id <- map["data.user_id"]
        status <- map["status"]
    }
}
