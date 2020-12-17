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
        audioStream?.repeatControl.delay(time: t)
    }

    func change(times num: Int){
        audioStream?.repeatControl.did(repeat: num)
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
            
            // 还是使用持久化好，
            
            // 直接使用控件，没有那么灵敏
            
            // 播放更改 progress,
            
            // 拖动滚动条 progress bar, 修改 progress,
            
            // 又影响播放时间，
            
            // 播放时间影响 progress bar,
            update(metric: val)
        }
    }
    
    
}




