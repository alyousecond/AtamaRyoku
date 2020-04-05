//
//  AppWireframe.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit

struct AppWireframe {
    func showDescription() {
        let viewController = rootViewController()
        let nextViewController = AppBuilder().buildDescriptionView()
        nextViewController.modalPresentationStyle = .fullScreen
        viewController.present(nextViewController, animated: false, completion: nil)
    }
    
    func showAtamaRyoku() {
        let viewController = rootViewController()
        let nextViewController = AppBuilder().buildAtamaRyokuView()
        nextViewController.modalPresentationStyle = .fullScreen
        viewController.present(nextViewController, animated: false, completion: nil)
    }
    
    func showRanking() {
        let viewController = rootViewController()
        let nextViewController = AppBuilder().buildRankingView()
        nextViewController.modalPresentationStyle = .fullScreen
        viewController.present(nextViewController, animated: false, completion: nil)
    }
    
    func rootViewController() -> UIViewController {
        return ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController)!
    }
}
