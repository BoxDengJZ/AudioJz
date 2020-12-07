//
//  Date.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/11.
//  Copyright © 2019 Jz D. All rights reserved.
//

import Foundation



extension Date {
    
    static var currentTimeStamp: String{
        return String(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    
    
    
}


extension Date {
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    
    var inTheDay: Bool{
        let result = Calendar.current.dateComponents([Calendar.Component.day], from: self, to: Date()).value(for: Calendar.Component.day)
        if let gluteals = result, gluteals == 0{
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
    static var days: String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        return dateFormatter.string(from: date)
    }
}



extension Date{
    var intVal: Int?{
        if let d = Date.coordinate{
             let inteval = Date().timeIntervalSince(d)
             return Int(inteval)
        }
        return nil
    }


    // today's time is close to `2020-04-17 05:06:06`

    static let coordinate: Date? = {
        let dateFormatCoordinate = DateFormatter()
        dateFormatCoordinate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let d = dateFormatCoordinate.date(from: "2020-04-17 05:06:06") {
            return d
        }
        return nil
    }()
}




extension TimeInterval {
    
    /// Converts a `TimeInterval` into a MM:SS formatted string.
    ///
    /// - Returns: A `String` representing the MM:SS formatted representation of the time interval.
    var mmSS: String {
        let ts = Int(self)
        let s = ts % 60
        let m = (ts / 60) % 60
        return String(format: "%02d:%02d", m, s)
    }
    
}



extension Int {
    
    /// Converts a `TimeInterval` into a MM:SS formatted string.
    ///
    /// - Returns: A `String` representing the MM:SS formatted representation of the time interval.
    var mmSS: String {
        TimeInterval(self).mmSS
    }
    
}
