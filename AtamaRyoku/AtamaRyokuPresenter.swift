//
//  atamaRyokuPresenter.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation
import RxSwift

enum viewStatus: Int {
    case start
    case countDownFirst
    case clearPanel
    case countDownSecond
    case numberPanel
    case result
    case compliment
    case done
}

protocol AtamaRyokuPresenterInput {
    //var infoViewStatus: Observable<Bool> { get }
    //var gameViewStatus: Observable<Bool> { get }
    //var actionViewStatus: Observable<Bool> { get }
    var maxNumber: Int { get }
    var viewPanel: Observable<(action: Bool, info: Bool, game: Bool, result: Bool)> { get }
    var gamePanel: Observable<buttonStatus> { get }
    
    var infoLabel: Observable<String> { get }
    var resultLabel: Observable<String> { get }
    
    var rightNumberPressed: Observable<Bool> { get }
    
    func tapActionButton()
    func checkNumber(tapNumber: Int) -> Bool
    func didChangeStatus()
    
    func pauseRecord()
    func restartRecord()
    
    func initNumbers() -> Array<Int>
}

class AtamaRyokuPresenter {
    var useCase: RankingUseCaseInput!
    //fileprivate let actionViewStatusSubject = BehaviorSubject(value: true)
    //fileprivate let infoViewStatusSubject = BehaviorSubject(value: false)
    //fileprivate let gameViewStatusubject = BehaviorSubject(value: false)
    fileprivate let viewPanelSubject = PublishSubject<(action: Bool, info: Bool, game: Bool, result: Bool)>()
    fileprivate let gamePanelSubject = PublishSubject<buttonStatus>()
    
    fileprivate let infoLabelSubject = PublishSubject<String>()
    fileprivate let resultLabelSubject = PublishSubject<String>()
    
    fileprivate let rightNumberPressedSubject = PublishSubject<Bool>()
    
    var status: viewStatus = .start // .numberPanel //
    var counter: Int = 0
    var currentNumber: Int = 0
    var timer: Timer!
    var rankingEntity: RankingEntity?
    let maxNumber = 42
    //var numbers: Array<Int>
    
    func inject(usecase: RankingUseCaseInput) {
        self.useCase = usecase
    }
}

//MARK: private
extension AtamaRyokuPresenter {
    func startRecord() {
        rankingEntity = RankingEntity()
    }

    func endRecord() {
        rankingEntity?.endTime = NSDate().timeIntervalSince1970
        rankingEntity?.time += (rankingEntity?.endTime)! - (rankingEntity?.startTime)!
        useCase.addRanking(entity: rankingEntity!)
    }
    
    func checkNumber(tapNumber: Int) -> Bool {
        var correct = false
        if (tapNumber == currentNumber) {
            currentNumber += 1
            correct = true
        }
        else {
            correct = false
        }
        
        //if (currentNumber > 4) {
        if (currentNumber > maxNumber) {
            endRecord()
            nextStep()
            return true
        }
        else {
            return correct
        }
    }
}

extension AtamaRyokuPresenter: AtamaRyokuPresenterInput {

    //var actionViewStatus: Observable<Bool>  { return actionViewStatusSubject }
    //var infoViewStatus: Observable<Bool>    { return infoViewStatusSubject }
    //var gameViewStatus: Observable<Bool>    { return gameViewStatusubject }

    var viewPanel : Observable<(action: Bool, info: Bool, game: Bool, result: Bool)>  { return viewPanelSubject }
    var gamePanel : Observable<buttonStatus> { return gamePanelSubject }
    
    var infoLabel : Observable<String> { return infoLabelSubject }
    var resultLabel : Observable<String> { return resultLabelSubject }
    var rightNumberPressed : Observable<Bool> { return rightNumberPressedSubject }
    
    func pauseRecord() {
        rankingEntity?.endTime = NSDate().timeIntervalSince1970
        rankingEntity?.time += (rankingEntity?.endTime)! - (rankingEntity?.startTime)!
    }

    func restartRecord() {
        rankingEntity?.startTime = NSDate().timeIntervalSince1970
        rankingEntity?.endTime = (rankingEntity?.startTime)!
    }
    
    func initNumbers() -> Array<Int> {
        var numbers: Array<Int> = Array()
        for i in 1...maxNumber {
            numbers.append(i)
        }
        return numbers.shuffled()
    }
    
    @objc func nextStep() { Log()
        let current = status.rawValue
        let next = current + 1
        if let status = viewStatus(rawValue: next) {
            self.status = status
        }
        else {
            self.status = .start
        }
        didChangeStatus()
    }
    
    @objc func beginCount() { Log()
        if (counter == 0) {
            nextStep()
        }
        else {
            infoLabelSubject.onNext("\(counter)")
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(beginCount), userInfo: nil, repeats: false)
        }
        counter -= 1
    }
    
    func tapActionButton() { Log()
        nextStep()
    }
    
    func didChangeStatus() { Log()
        switch status {
        case .start:
            viewPanelSubject.onNext((action: false, info: true, game: true, result: true))
        case .countDownFirst:
            viewPanelSubject.onNext((action: true, info: false, game: true, result: true))
            counter = 3
            beginCount()
        case .clearPanel:
            viewPanelSubject.onNext((action: true, info: true, game: false, result: true))
            gamePanelSubject.onNext(.none)
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextStep), userInfo: nil, repeats: false)
        case .countDownSecond:
            viewPanelSubject.onNext((action: true, info: false, game: true, result: true))
            counter = 5
            beginCount()
        case .numberPanel:
            viewPanelSubject.onNext((action: true, info: true, game: false, result: true))
            gamePanelSubject.onNext(.normal)
            currentNumber = 1
            startRecord()
            //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(nextStep), userInfo: nil, repeats: false)
        case .result:
            viewPanelSubject.onNext((action: true, info: true, game: true, result: false))
            let time = IVWTime(interval: (rankingEntity?.time)!)
            resultLabelSubject.onNext(time.timeFormatString())
            //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(nextStep), userInfo: nil, repeats: false)
        case .compliment:
            viewPanelSubject.onNext((action: true, info: false, game: true, result: true))
            infoLabelSubject.onNext("がんばったね！")
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextStep), userInfo: nil, repeats: false)
        case .done:
            viewPanelSubject.onCompleted()
        }
    }
}
