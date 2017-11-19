//
//  FileListTableViewCell.swift
//  iOSCleanArchitectureSample
//
//  Created by Yuji Sugaya on 2017/07/26.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateCell(_ rankingViewModel: RankingViewModel) {
        self.rankLabel.text = "\(rankingViewModel.rank!)"
        
        let time = IVWTime(interval: rankingViewModel.time)
        self.timeLabel.text = time.timeFormatString()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        self.dateLabel.text = dateFormatter.string(from: rankingViewModel.rankingDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
