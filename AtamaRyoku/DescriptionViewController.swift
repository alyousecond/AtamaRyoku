//
//  descriptionViewController.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DescriptionViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    
    fileprivate let disposeBag = DisposeBag()
    
    var presenter: DescriptionPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        presenter.descriptionText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        presenter.pageText
            .bind(to: pageLabel.rx.text)
            .disposed(by: disposeBag)
        presenter.prevButtonEnable
            .bind(to: prevButton.rx.isEnabled)
            .disposed(by: disposeBag)
        presenter.nextButtonEnable
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        /*
        presenter.descriptionText
            .subscribe(
                onNext: { [weak self] (text: String) in
                    self?.descriptionLabel.text = text
                }
            )
            .disposed(by: disposeBag)
        
        presenter.pageText
            .subscribe(
                onNext: { [weak self] (text: String) in
                    self?.pageLabel.text = text
                }
            )
            .disposed(by: disposeBag)
        
        presenter.prevButtonEnable
            .subscribe(
                onNext: { [weak self] (enabled: Bool) in
                    self?.prevButton.isEnabled = enabled
                }
            )
            .disposed(by: disposeBag)
        
        presenter.nextButtonEnable
            .subscribe(
                onNext: { [weak self] (enabled: Bool) in
                    self?.nextButton.isEnabled = enabled
                }
            )
            .disposed(by: disposeBag)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inject(presenter: DescriptionPresenterInput) {
        self.presenter = presenter
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: IBAction
extension DescriptionViewController {
    @IBAction func tapBackButton(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
    @IBAction func tapNextButton(_ sender: AnyObject) {
        presenter.nextPage()
    }
    @IBAction func tapPrevButton(_ sender: AnyObject) {
        presenter.prevPage()
    }
}
