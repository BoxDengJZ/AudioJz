//
//  P_Ctrl_bg.swift
//  petit
//
//  Created by Jz D on 2020/11/23.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation
import UIKit

import MediaPlayer

extension PlayerController{
    
    func showMediaInfo(){
        let artistName = "DNG"
        
        
        guard let duration = durationPropaganda else {
            return
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist : artistName,  MPMediaItemPropertyTitle : "不应有恨",
                                                           MPNowPlayingInfoPropertyElapsedPlaybackTime: Double(progressV.val),
            MPMediaItemPropertyPlaybackDuration: duration]
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let e = event else{
            return
        }
        
        
        if e.type == UIEvent.EventType.remoteControl{
            switch e.subtype{
            case UIEvent.EventSubtype.remoteControlPlay:
                secondPlay()
            case UIEvent.EventSubtype.remoteControlPause:
                secondPlay()
            case UIEvent.EventSubtype.remoteControlNextTrack:
                to(page: .rhs)
            case UIEvent.EventSubtype.remoteControlPreviousTrack:
                to(page: .lhs)
            default:
                print("There is an issue with the control")
            }
        }


    }
    
    
    
    
}
