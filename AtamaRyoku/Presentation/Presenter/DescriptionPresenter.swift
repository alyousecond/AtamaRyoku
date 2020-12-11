//
//  descriptionPresenter.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Descrption {
    let descrptions = [
        "１から４２までうつし出されます。",
        "１から４２までじゅんばんに、ばんごうをおしていきます。",
        "ストップしたいときは右上のボタンをおします。"
    ]
    
    func page(_ page: Int) -> String {
        return descrptions[page]
    }
}

protocol DescriptionPresenterInput {
    var descriptionText: Observable<String> { get }
    var pageText: Observable<String> { get }
    var prevButtonEnable: Observable<Bool> { get }
    var nextButtonEnable: Observable<Bool> { get }
    
    func nextPage()
    func prevPage()
}

class DescriptionPresenter {
    fileprivate let descriptionTextVar = BehaviorRelay<String>(value: Descrption().page(0))
    fileprivate let pageTextVar = BehaviorRelay<String>(value: "1/3")
    fileprivate let prevButtonEnableVar = BehaviorRelay(value: false)
    fileprivate let nextButtonEnableVar = BehaviorRelay(value: true)
    
    fileprivate let maxPage = 3
    //fileprivate 
    var currentPage = 1
    
    func changePage() {
        prevButtonEnableVar.accept(true)
        nextButtonEnableVar.accept(true)
        
        if (currentPage == 1) {
            prevButtonEnableVar.accept(false)
        }
        else if (currentPage >= maxPage) {
            nextButtonEnableVar.accept(false)
        }
        pageTextVar.accept(String(format: "%d/%d", currentPage, maxPage))
        descriptionTextVar.accept(Descrption().page(currentPage - 1))
    }
}

extension DescriptionPresenter: DescriptionPresenterInput {
    var descriptionText: Observable<String> { return descriptionTextVar.asObservable() }
    var pageText: Observable<String> { return pageTextVar.asObservable() }
    var prevButtonEnable: Observable<Bool> { return prevButtonEnableVar.asObservable() }
    var nextButtonEnable: Observable<Bool> { return nextButtonEnableVar.asObservable() }
    
    func nextPage() {
        currentPage += 1
        changePage()
    }
    
    func prevPage() {
        currentPage -= 1
        changePage()
    }
}
