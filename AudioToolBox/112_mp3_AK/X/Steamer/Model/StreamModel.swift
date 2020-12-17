//
//  StreamModel.swift
//  petit
//
//  Created by Jz D on 2020/10/20.
//  Copyright © 2020 Jz D. All rights reserved.
//

import Foundation







struct AudioRecord{
    
    // 重复
    var countStdRepeat = BottomPopData.times[BottomPopData.times.count / 2]
    var howManyNow = 0
    var toClimb = true
    
    
    
    
    var currentX = 0
    
    
    
    // pause , 停顿
    var pauseWork = false
    var currentMoment = Date()
    
    var stdPauseT: TimeInterval = BottomPopData.interval[ BottomPopData.interval.count - 1 ]
    
    mutating
    func did(repeat idx: Int){
        countStdRepeat = BottomPopData.times[idx]
    }

    
    mutating
    func doPause(at index: Int){
        currentX = index + 1
        toClimb = true
        howManyNow = 0
        currentMoment = Date()
        pauseWork = true
    }
    
    
    
    mutating
    func delay(time t: TimeInterval){
        stdPauseT = t
    }
    
    
   
    
}
