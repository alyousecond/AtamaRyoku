//
//  ViewControllerBuilder.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit

struct AppBuilder {
    func buildTopPageView() -> TopPageViewController {
        let wireframe = AppWireframe()
        let presenter = TopPagePresenter(wireframe: wireframe)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TopPageViewController") as! TopPageViewController
        viewController.inject(presenter: presenter)
        //wireframe.viewController = viewController as topPageViewController
        return viewController
    }

    func buildDescriptionView() -> DescriptionViewController {
        let presenter = DescriptionPresenter()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        viewController.inject(presenter: presenter)
        return viewController
    }
    
    func buildAtamaRyokuView() -> AtamaRyokuViewController {
        let usecase = RankingUseCase()
        let presenter = AtamaRyokuPresenter()
        presenter.inject(usecase: usecase)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AtamaRyokuViewController") as! AtamaRyokuViewController
        viewController.inject(presenter: presenter)
        return viewController
    }
    
    func buildRankingView() -> RankingViewController {
        let useCase = RankingUseCase()
        let presenter = RankingPresenter()
        presenter.inject(useCase: useCase)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RankingViewController") as! RankingViewController
        viewController.inject(presenter: presenter)
        return viewController
    }
    
}
