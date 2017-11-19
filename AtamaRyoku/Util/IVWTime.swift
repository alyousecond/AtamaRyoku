//
//  IVWTime.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/24.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation

class IVWTime {
    var hour: Int
    var minute: Int
    var second: Double
    
    let IVWLapTimeDaySec = 86400.0
    let IVWLapTimeHourSec = 3600.0
    let IVWLapTimeMinuteSec = 60.0
    
    public required init(interval: Double) {
        var timeInterval = interval;
        
        if (timeInterval >= IVWLapTimeDaySec) {
            timeInterval = timeInterval - IVWLapTimeDaySec;
        }
        
        //時間の計算
        hour = Int(timeInterval / IVWLapTimeHourSec);
        //分の計算
        minute = Int((timeInterval - Double(hour) * IVWLapTimeHourSec) / IVWLapTimeMinuteSec);
        //秒の計算
        //トータルから時間、分の秒を除く
        second = timeInterval - (Double(hour) * IVWLapTimeHourSec) - (Double(minute) * IVWLapTimeMinuteSec);
    }
    
    func timeFormatString() -> String {
        return String(format: "%02d分%02.0fびょう", minute, second)
    }
}
