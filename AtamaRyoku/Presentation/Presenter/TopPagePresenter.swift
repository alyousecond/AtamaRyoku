//
//  topPagePresenter.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation

protocol TopPagePresenterInput {
    func tapDescriptionButton()
    func tapAtamaRyokuButton()
    func tapRankingButton()
}

struct TopPagePresenter {
    let wireframe: AppWireframe
    
    public init(wireframe: AppWireframe) {
        self.wireframe = wireframe
    }
}

extension TopPagePresenter: TopPagePresenterInput {
    func tapDescriptionButton() { Log()
        wireframe.showDescription()
    }
    func tapAtamaRyokuButton() { Log()
        wireframe.showAtamaRyoku()
    }
    func tapRankingButton() { Log()
        wireframe.showRanking()
    }
}
