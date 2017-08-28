//
//  rankingPresenter.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation
import RxSwift

enum ListStatus {
    case none
    case notAuthorized
    case loading
    case normal
    case error
}

protocol RankingPresenterInput {
    var listStatusTotal: Observable<ListStatus> { get }
    var listStatusToday: Observable<ListStatus> { get }
    
    var todayRanking: Observable<Array<RankingViewModel>> { get }
    var totalRanking: Observable<Array<RankingViewModel>> { get }
    
    func loadTodayRanking()
    func loadTotalRanking()
}

class RankingPresenter {
    var useCase: RankingUseCaseInput!
    
    fileprivate let listStatusTotalSubject = PublishSubject<ListStatus>()
    fileprivate let listStatusTodaySubject = PublishSubject<ListStatus>()
    fileprivate let todayRankingSubject = PublishSubject<Array<RankingViewModel>>()
    fileprivate let totalRankingSubject = PublishSubject<Array<RankingViewModel>>()
    
    fileprivate let disposeBag = DisposeBag()
    
    func inject(useCase: RankingUseCaseInput) {
        self.useCase = useCase
        
        useCase.todayRanking
            .subscribe(
                onNext: { [weak self] (rankingsEntity: Array<RankingEntity>) in
                    let rankingsViewModel = self?.convertFromEntity(rankingsEntity: rankingsEntity)
                    self?.todayRankingSubject.onNext(rankingsViewModel!)
                    self?.listStatusTodaySubject.onNext(.normal)
                }
            )
            .disposed(by: disposeBag)
        
        useCase.totalRanking
            .subscribe(
                onNext: { [weak self] (rankingsEntity: Array<RankingEntity>) in
                    let rankingsViewModel = self?.convertFromEntity(rankingsEntity: rankingsEntity)
                    self?.totalRankingSubject.onNext(rankingsViewModel!)
                    self?.listStatusTotalSubject.onNext(.normal)
                }
            )
            .disposed(by: disposeBag)
    }
}

extension RankingPresenter: RankingPresenterInput {
    var listStatusTotal: Observable<ListStatus> { return listStatusTotalSubject }
    var listStatusToday: Observable<ListStatus> { return listStatusTodaySubject }
    var todayRanking: Observable<Array<RankingViewModel>> { return todayRankingSubject }
    var totalRanking: Observable<Array<RankingViewModel>> { return totalRankingSubject }
    
    func loadTodayRanking() {
        useCase.loadTodayRanking()
    }
    
    
    func loadTotalRanking() {
        useCase.loadTotalRanking()
    }
}

// MARK: Private
extension RankingPresenter {
    func convertFromEntity(rankingsEntity: Array<RankingEntity>) -> Array<RankingViewModel> {
        var rankingsViewModel: Array<RankingViewModel> = Array()
        var rank = 1
        rankingsEntity.forEach { ranking in
            rankingsViewModel.append(
                RankingViewModel(
                    rank: rank,
                    rankingKey: ranking.rankingKey,
                    time: ranking.time,
                    rankingDate: ranking.rankingDate,
                    startTime: ranking.startTime,
                    endTime: ranking.endTime
                )
            )
            rank += 1
        }
        return rankingsViewModel
    }
}
