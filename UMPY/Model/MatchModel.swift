//
//  MatchModel.swift
//  UMPY
//
//  Created by CBDev on 3/22/19.
//  Copyright © 2019 CBDev. All rights reserved.
//

import Foundation
class MatchModel{
    var matchName: String?
    var matchTime: String?
    
    init(matchName: String, matchTime: String) {
        self.matchName = matchName
        self.matchTime = matchTime
    }
}
