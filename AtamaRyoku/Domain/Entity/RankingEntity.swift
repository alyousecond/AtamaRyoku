//
//  RankingEntity.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/24.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation

struct RankingEntity {
    var rankingKey = String(format: "%.10f", NSDate().timeIntervalSince1970)
    var time = 0.0
    var rankingDate = Date()
    var startTime = NSDate().timeIntervalSince1970
    var endTime = NSDate().timeIntervalSince1970
}
