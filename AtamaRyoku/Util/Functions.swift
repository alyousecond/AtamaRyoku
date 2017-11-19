//
//  functions.swift
//  SnapZip
//
//  Created by Yuji Sugaya on 2017/07/13.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import UIKit

func Log(_ args: String..., function: String = #function, filePath: String = #file, line: Int = #line) {
    
    let file = (filePath as NSString).lastPathComponent
    
    var message = ""
    if (args.count == 1) {
        message = args[0]
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
    let date = dateFormatter.string(from: Date())
    
    #if DEBUG
        //print("INPUT \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
        //print("INPUT \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
        print("\(date) [\(file):\(function):\(line)] \(message)")
    #elseif DEBUG_STAGING
        print("INPUT \(message)")
    #else
    #endif
}

func dayString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter.string(from: date)
}
