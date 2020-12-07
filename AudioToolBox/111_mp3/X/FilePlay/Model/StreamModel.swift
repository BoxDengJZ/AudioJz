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
    var countStdRepeat = 0
    var howManyNow = 0
    var toClimb = true
    
    
    
    
    var currentX = 0
    
    
    
    // pause , 停顿
    var pauseWork = false
    var currentMoment = Date()
    
    var stdPauseT: TimeInterval = BottomPopData.interval[3]
    
    mutating
    func did(repeat times: Int){
        countStdRepeat = times - 1
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
