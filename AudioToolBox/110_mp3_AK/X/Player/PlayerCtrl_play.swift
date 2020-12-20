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
  
        guard audioStream == nil else {
            return
        }
        let pIt = pIntelliJ_std
        let moments = pIt.list.map { (node) -> TimeInterval in
            node.time
        }
        audioStream = Streamer(source: fileP, with: moments, bridge: self)
        audioStream?.volumeRampTargetValue = src.voiceLevel
        if src.isAAC{
            audioStream?.sourceURL = Bundle.main.url(forResource: src.music, withExtension: "m4a")
        }
        else{
            audioStream?.sourceURL = Bundle.main.url(forResource: src.music, withExtension: "mp3")
        }
        
        

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
         
         
         audioStream?.playS()
    
         bottomBoard.p_play(second: false)
     }
     
     
     
     
     func toPause(){
        audioStream?.firstPause = true
        audioStream?.pauseS()
        bottomBoard.p_play(second: true)
     }
    
    
   
}

