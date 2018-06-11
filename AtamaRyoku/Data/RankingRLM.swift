//
//  RankingRLM.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import RealmSwift

class RankingRLM: Object {
    @objc dynamic var rankingKey: String = String(format: "%.10f", NSDate().timeIntervalSince1970)
    @objc dynamic var time: Double = 0.0
    @objc dynamic var rankingDate: Date = Date()
    @objc dynamic var startTime: Double = 0.0
    @objc dynamic var entTime: Double = 0.0
    @objc dynamic var day: String = ""

    override static func primaryKey() -> String? {
        return "rankingKey"
    }
}
