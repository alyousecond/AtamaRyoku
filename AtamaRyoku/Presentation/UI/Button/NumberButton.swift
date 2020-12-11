//
//  numberButton.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/20.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit
import RxSwift

enum buttonStatus {
    case normal
    case none
    case done
}

@IBDesignable class NumberButton: UIButton {
    var buttonStatus: buttonStatus = .normal
    var number: Int = 0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // 角丸の半径(0で四角形)
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    // 枠
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        // 角丸
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = (cornerRadius > 0)
        
        // 枠線
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        didChangeStatus()
        
        super.draw(rect)
    }
}

extension NumberButton {
    func didChangeStatus() {
        switch buttonStatus {
        case .normal:
            self.setTitle("\(number)", for: UIControl.State.normal)
            self.isHidden = false
        case .none:
            self.setTitle("", for: UIControl.State.normal)
            self.isHidden = false
        case .done:
            self.setTitle("-1", for: UIControl.State.normal)
            self.isHidden = true
        }
    }
}
