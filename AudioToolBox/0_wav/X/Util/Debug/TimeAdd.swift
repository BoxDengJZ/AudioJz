
//
//  Time.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/30.
//  Copyright © 2019 Jz D. All rights reserved.
//

import Foundation



extension Date{
    
    static func log(_ info: String = ""){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH: mm: ss"
        let date = Date()
        let start = dateFormatter.string(from: date)
        print(info, start, "\n")
    }
    
}


extension Date{
    
    static func debug(_ placeHolder: String = "当前时间是：   "){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: date)
        print(placeHolder, time)
    }

    
    static func benchmark(_ body: @escaping () -> Void){
        let start = Date()
        body()
        let end = Date()
        let result = end.timeIntervalSince(start)
        print("运行时长: \(result)")
    }
    
    
}




extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    static var timeStamp: String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    
    
    
    
    /// 获取当前 毫秒级 时间戳 - 13位
    static var milliStamp: String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }

    
    static var milli: CLongLong {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
    
    
    static var mi: Double {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        return timeInterval * 1000
    }
    


}

