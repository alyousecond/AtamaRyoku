//
//  descriptionPresenter.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation
import RxSwift

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
    fileprivate let descriptionTextVar = Variable<String>(Descrption().page(0))
    fileprivate let pageTextVar = Variable<String>("1/3")
    fileprivate let prevButtonEnableVar = Variable(false)
    fileprivate let nextButtonEnableVar = Variable(true)
    
    fileprivate let maxPage = 3
    fileprivate var currentPage = 1
    
    func changePage() {
        if (currentPage == 1) {
            prevButtonEnableVar.value = false
            nextButtonEnableVar.value = true
        }
        else if (currentPage >= maxPage) {
            prevButtonEnableVar.value = true
            nextButtonEnableVar.value = false
        }
        pageTextVar.value = String(format: "%d/%d", currentPage, maxPage)
        descriptionTextVar.value = Descrption().page(currentPage - 1)
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
