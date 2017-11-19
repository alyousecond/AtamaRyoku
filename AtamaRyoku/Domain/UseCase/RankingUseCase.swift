//
//  ranking.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol RankingUseCaseInput {
    var todayRanking: Observable<Array<RankingEntity>> { get }
    var totalRanking: Observable<Array<RankingEntity>> { get }
    
    func addRanking(entity: RankingEntity)
    func loadTodayRanking()
    func loadTotalRanking()
}

struct RankingUseCase {
    let maxCount = 10
    fileprivate let todayRankingSubject = PublishSubject<Array<RankingEntity>>()
    fileprivate let totalRankingSubject = PublishSubject<Array<RankingEntity>>()
}

extension RankingUseCase : RankingUseCaseInput {
    var todayRanking: Observable<Array<RankingEntity>> { return todayRankingSubject }
    var totalRanking: Observable<Array<RankingEntity>> { return totalRankingSubject }
    
    func addRanking(entity: RankingEntity) {
        let realm = try! Realm()
        try! realm.write {
            let ranking = RankingRLM()
            ranking.rankingKey = entity.rankingKey
            ranking.rankingDate = entity.rankingDate
            ranking.time = entity.time
            ranking.startTime = entity.startTime
            ranking.entTime = entity.endTime
            ranking.day = dayString(date: entity.rankingDate)
            realm.add(ranking, update: true)
        }
    }
    
    func loadTodayRanking() {
        // Get the default Realm
        let realm = try! Realm()
        let rankingsRealm = realm.objects(RankingRLM.self).filter("day == %@", dayString(date: Date())).sorted(byKeyPath: "time", ascending: true)
        let rankingsEntity = convertFromRealm(rankingsRealm: rankingsRealm)
        todayRankingSubject.onNext(rankingsEntity)
    }
    
    func loadTotalRanking() {
        // Get the default Realm
        let realm = try! Realm()
        let rankingsRealm = realm.objects(RankingRLM.self).sorted(byKeyPath: "time", ascending: true)
        let rankingsEntity = convertFromRealm(rankingsRealm: rankingsRealm)
        totalRankingSubject.onNext(rankingsEntity)
    }
    
    func convertFromRealm(rankingsRealm: Results<RankingRLM>) -> Array<RankingEntity> {
        var rankingsEntity: Array<RankingEntity> = Array()
        let max = rankingsRealm.count < maxCount ? rankingsRealm.count : maxCount
        for i in (0 ..< max) {
            rankingsEntity.append(
                RankingEntity(
                    rankingKey: rankingsRealm[i].rankingKey,
                    time: rankingsRealm[i].time,
                    rankingDate: rankingsRealm[i].rankingDate,
                    startTime: rankingsRealm[i].startTime,
                    endTime: rankingsRealm[i].entTime
                )
            )
        }
        /*
        rankingsRealm.forEach { ranking in
            rankingsEntity.append(
                RankingEntity(
                    rankingKey: ranking.rankingKey,
                    time: ranking.time,
                    rankingDate: ranking.rankingDate,
                    startTime: ranking.startTime,
                    endTime: ranking.entTime
                )
            )
        }
    */
        return rankingsEntity
    }
}
