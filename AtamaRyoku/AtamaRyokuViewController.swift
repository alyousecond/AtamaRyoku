//
//  atamaRyokuViewController.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit
import RxSwift

class AtamaRyokuViewController: UIViewController {
    @IBOutlet weak var actionView: ActionView!
    @IBOutlet weak var infoView: InfoView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameCollectionView: GameView!
    @IBOutlet weak var resultView: ResultView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var buttonStatus: buttonStatus = .none
    var presenter: AtamaRyokuPresenterInput!
    fileprivate let disposeBag = DisposeBag()

    var numbers: Array<Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter.viewPanel
            .subscribe(
                onNext: { [weak self] (action: Bool, info: Bool, game: Bool, result: Bool) in
                    self?.actionView.isHidden = action
                    self?.infoView.isHidden = info
                    self?.gameView.isHidden = game
                    self?.resultView.isHidden = result
                },
                onCompleted: { [weak self] () in
                    self?.dismiss(animated: false, completion: {})
                }
            ).disposed(by: disposeBag)
        
        presenter.gamePanel
            .subscribe(
                onNext: { [weak self] (status: buttonStatus) in
                    switch status {
                    case .none:
                        self?.pauseButton.isHidden = true
                    case .normal:
                        self?.pauseButton.isHidden = false
                    default:
                        break
                    }
                    self?.buttonStatus = status
                    self?.numbers = self?.presenter.initNumbers()
                    self?.gameCollectionView.reloadData()
                }
            ).disposed(by: disposeBag)
    
        
        presenter.infoLabel
            .subscribe(
                onNext: { [weak self] (info: String) in
                    self?.infoView.infoLable.text = info
                }
            ).disposed(by: disposeBag)

        presenter.resultLabel
            .subscribe(
                onNext: { [weak self] (info: String) in
                    self?.resultView.ResultLabel.text = info
                }
            ).disposed(by: disposeBag)

        presenter.didChangeStatus()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inject(presenter: AtamaRyokuPresenterInput) { Log()
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

extension AtamaRyokuViewController : UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int { Log()
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { Log()
        switch self.buttonStatus {
        case .normal:
            if let numberOfItems = numbers?.count {
                return numberOfItems
            }
            else {
                return 0
            }
        default:
            return (presenter?.maxNumber)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { Log()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCollectionViewCell", for: indexPath) as! NumberCollectionViewCell
        
        switch self.buttonStatus {
        case .none:
            cell.setButtonStatus(status: self.buttonStatus)
        default:
            if let number = numbers?[indexPath.row] {
                cell.numberButton.number = number
            }
            else {
                cell.numberButton.number = -1
            }
            cell.tapNumber
                .subscribe(
                    onNext: { [weak self] (number: Int) in
                        if (self?.presenter.checkNumber(tapNumber: number))! {
                            cell.correct(button: cell.numberButton)
                        }
                    }
                ).disposed(by: disposeBag)
            cell.setButtonStatus(status: self.buttonStatus)
        }

        return cell
    }
}

extension AtamaRyokuViewController {
    @IBAction func tapBackButton(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
    @IBAction func tapActionButton(_ sender: AnyObject) {
        self.presenter.tapActionButton()
    }
    @IBAction func tapPauseButton(_ sender: AnyObject) {
        presenter.pauseRecord()
        
        let alert: UIAlertController = UIAlertController(title: "かくにん", message: "テストをおわりますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "おわる", style: UIAlertActionStyle.default, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in
            self?.dismiss(animated: false, completion: {})
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "つづける", style: UIAlertActionStyle.cancel, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in
            self?.presenter.restartRecord()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
