//
//  numberCollectionViewCell.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/21.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit
import RxSwift

class NumberCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var numberButton: NumberButton!
    var tapNumber: Observable<Int> { return tapNumberSubject }
    
    fileprivate let tapNumberSubject = PublishSubject<Int>()
    
    @IBAction func tapNumberButton(_ sender: AnyObject) {
        if let numberButton = sender as? NumberButton {
            tapNumberSubject.onNext(numberButton.number)
        }
    }
    
    func correct(button: NumberButton) {
        button.buttonStatus = .done
        button.didChangeStatus()
    }
    
    func setButtonStatus(status: buttonStatus) {
        numberButton.buttonStatus = status
        numberButton.didChangeStatus()
    }
}
