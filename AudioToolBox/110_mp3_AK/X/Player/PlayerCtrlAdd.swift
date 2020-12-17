//
//  ViewCtrlAdd.swift
//  petit
//
//  Created by Jz D on 2020/10/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


import AVFoundation


extension PlayerController: StreamingDelegate{
    func streamer(ok finalT: TimeInterval) {
        
    }
    
 
    
    func streamer(dng streamer: Streaming, changedState state: StreamingState) {
        switch state {
        case .playing:
            ()
        case .paused:
            ()
        case .stopped:
            ()
        case .over:
            bottomBoard.p_play(second: true)
            playingSelected = false
        }
    }
    
    
    
    
    func streamer(fire streamer: Streaming, updatedCurrentTime current: TimeInterval) {
          progressV.config(current: current)
          showMediaInfo()
      //    update(metric: Float(current))
          
    }
    
    
    
    
    
    func streamer(_ streamer: Streaming, updatedDuration duration: TimeInterval) {
        durationPropaganda = duration
        config(duration: duration)
        let cake = pIntelliJ_std
        calibrationView.tubes = cake.oreoPercent(duration: duration)
    }
    
    
    
}




