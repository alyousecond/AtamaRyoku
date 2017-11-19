//
//  rankingViewController.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit
import RxSwift

enum RankingViewTag: Int {
    case totalRanking = 100
    case todayRanking = 200
}

class RankingViewController: UIViewController {
    var presenter: RankingPresenterInput!
    
    @IBOutlet weak var todayView: UITableView!
    @IBOutlet weak var totalView: UITableView!
    
    var listStatusTotal: ListStatus = .normal
    var listStatusToday: ListStatus = .normal
    
    var totalRanking: Array<RankingViewModel> = Array()
    var todayRanking: Array<RankingViewModel> = Array()
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
        
        presenter.totalRanking
            .subscribe(
                onNext: { [weak self] (totalRanking) in
                    self?.totalRanking = totalRanking
                }
        ).disposed(by: disposeBag)

        presenter.todayRanking
            .subscribe(
                onNext: { [weak self] (todayRanking) in
                    self?.todayRanking = todayRanking
                }
            ).disposed(by: disposeBag)

        presenter.listStatusToday
            .subscribe(
                onNext: { [weak self] (listStatus) in
                    self?.listStatusToday = listStatus
                    self?.todayView.reloadData()
                }
            ).disposed(by: disposeBag)
        
        presenter.listStatusTotal
            .subscribe(
                onNext: { [weak self] (listStatus) in
                    self?.listStatusTotal = listStatus
                    self?.totalView.reloadData()
                }
            ).disposed(by: disposeBag)
        
        presenter.loadTotalRanking()
        presenter.loadTodayRanking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inject(presenter: RankingPresenterInput) {
        self.presenter = presenter
    }
    
    func setUpView() {
        self.todayView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        self.totalView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
    }
}

extension RankingViewController {
    @IBAction func tapBackButton(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
}

extension RankingViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { Log()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { Log()
        switch tableView.tag {
        case RankingViewTag.totalRanking.rawValue:
            if (listStatusTotal == .normal) {
                return totalRanking.count
            }
            else {
                return 1
            }
        case RankingViewTag.todayRanking.rawValue:
            if (listStatusToday == .normal) {
                return todayRanking.count
            }
            else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        Log("\(tableView.tag)")
        switch tableView.tag {
        case RankingViewTag.totalRanking.rawValue:
            let rankingViewModel = totalRanking[indexPath.row]
            cell.updateCell(rankingViewModel)
        case RankingViewTag.todayRanking.rawValue:
            let rankingViewModel = todayRanking[indexPath.row]
            cell.updateCell(rankingViewModel)
        default:
            break
        }
        return cell
    }
}
