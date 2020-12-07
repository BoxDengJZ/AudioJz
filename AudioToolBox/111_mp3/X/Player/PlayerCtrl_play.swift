//
//  PlayerCtrl_play.swift
//  petit
//
//  Created by Jz D on 2020/11/2.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation

enum FileExistence{
    case no
    case path(URL)
}



extension PlayerController{


    func preparePlay(){
  
        guard audioStream == nil, let pIt = pIntelliJ_std else {
            return
        }
        
        let moments = pIt.list.map { (node) -> TimeInterval in
            node.time
        }
        audioStream = Streamer(source: fileP, with: moments, bridge: self)
        
        audioStream?.sourceURL = Bundle.main.url(forResource: "1_ひこうき雲", withExtension: "mp3")
        
        guard let duration = moments.last else {
            
            return
        }
        durationPropaganda = duration
        config(duration: duration)
        
    }

     
     func enterPlay(){
         playingSelected.toggle()
         if playingSelected{
             bottomBoard.p_pause()
             toPlay()

         }
     }
     
    
    
    
     func secondPlay(){
        playingSelected.toggle()
        if playingSelected{
            bottomBoard.p_play(second: false)
            toPlay()
 
            
        }
        else{
            bottomBoard.p_play(second: true)
            
            
            toPause()
            
            
        }
     }
    
     
     
     func toPlay(){
         
         
         audioStream?.climb(to: TimeInterval(progressV.val))
    
         bottomBoard.p_play(second: false)
     }
     
     
     
     
     func toPause(){
        audioStream?.firstPause = true
        audioStream?.pauseS()
        bottomBoard.p_play(second: true)
     }
    
    
   
}

