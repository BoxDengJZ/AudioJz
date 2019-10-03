//
//  MeterTable.swift
//  First
//
//  Created by dengjiangzhou on 2018/6/7.
//  Copyright © 2018年 dengjiangzhou. All rights reserved.
//

import Foundation

var debug = false

struct MeterTable {
    let minDb: Float = -60.0
    var tableSize: Int // 300
    
    let scaleFactor: Float
    var meterTable = [Float]()
    
    init (tableSize: Int) {
        self.tableSize = tableSize
        
        let dbResolution = Float(minDb / Float(tableSize - 1))
        scaleFactor = 1.0 / dbResolution
        let minAmp = dbToAmp(dB: minDb )
        // dbToAmp()
        
        let ampRange = 1.0 - minAmp
        let invAmpRange = 1.0 / ampRange
        
        for i in 0..<tableSize {
            let decibels = Float(i) * dbResolution
            let amp = dbToAmp(dB: decibels)
            let adjAmp = (amp - minAmp) * invAmpRange
            meterTable.append(adjAmp)
        }
    }
    
    //·分贝转振幅
    private func dbToAmp(dB: Float) -> Float {
        return powf(10.0, 0.05 * dB)
    }
    
    
    // 外部调用
    func valueForPower(power: Float) -> Float {
        if power < minDb {
            return 0.0
        }
        else if power >= 0.0 {
            return 1.0
        }
        else {
            let index = Int(power * scaleFactor)
            if debug{
                print("power")
                print(power)
                debug = false
                print("meterTable")
                print(meterTable)
                print("index")
                print(index)
            }
            return meterTable[index]
        }
    }
}
