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
        let nodes = pIntelliJ_std?.see.wav_lengths
        
        guard let moments = nodes else {
            return
        }
        
        audioStream = Streamer(source: fileP, with: moments, bridge: self)
        
        audioStream?.url_deng = Bundle.main.url(forResource: "in", withExtension: "pcm")
        
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

