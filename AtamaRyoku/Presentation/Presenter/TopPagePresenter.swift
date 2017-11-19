//
//  topPagePresenter.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation

protocol TopPagePresenterInput {
    func tagDescriptionButton()
    func tapAtamaRyokuButton()
    func tabRankingButton()
}

struct TopPagePresenter {
    let wireframe: AppWireframe
    
    public init(wireframe: AppWireframe) {
        self.wireframe = wireframe
    }
}

extension TopPagePresenter: TopPagePresenterInput {
    func tagDescriptionButton() { Log()
        wireframe.showDescription()
    }
    func tapAtamaRyokuButton() { Log()
        wireframe.showAtamaRyoku()
    }
    func tabRankingButton() { Log()
        wireframe.showRanking()
    }
}
