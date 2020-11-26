//
//  PlayerCtrlProxy.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation



extension PlayerController: BottomPlayBoardProxy{
    
    
    func change(interval t: TimeInterval) {
        audioStream?.shutUp.delay(time: t)
    }

    func change(times num: Int){
        audioStream?.shutUp.did(repeat: num)
    }
    
    
    
    func to(page direction: Orientation){
        // ...
    }

}




extension PlayerController: PlayerProgressProxy{
    
    func doTheProgress(player stus: PlayerProgressOption) {
        switch stus {
        case .play:
            if playingSelected{
                toPlay()
            }
            
        case .pause:
            if playingSelected{
                toPause()
            }
            
        case .update(let val):
            update(metric: val)
        }
    }
    
    
}




