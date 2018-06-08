//
//  ViewController.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit

class TopPageViewController: UIViewController {
    var presenter: TopPagePresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inject(presenter: TopPagePresenterInput) {
        self.presenter = presenter
    }
}

// MARK: IBAction
extension TopPageViewController {
    @IBAction func tapDescriptionButton(_ sender: AnyObject) { Log()
        presenter?.tapDescriptionButton()
    }
    @IBAction func tapAtamaRyokuButton(_ sender: AnyObject) { Log()
        presenter?.tapAtamaRyokuButton()
    }
    @IBAction func tapRankingButton(_ sender: AnyObject) { Log()
        presenter.tapRankingButton()
    }
}
