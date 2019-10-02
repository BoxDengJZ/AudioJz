//
//  Utils.swift
//  Sound Butler
//
//  Created by Michael Briscoe on 12/14/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation

var appHasMicAccess = true

enum AudioStatus: Int, CustomStringConvertible {
    case stopped = 0, playing, recording, interruptionPlaying, interruptionRecording
    
    var audioName: String {
        let audioNames = [
            "Audio:  Stopped",
            "Audio:  Playing",
            "Audio:  Recording",
            "Audio:  interruptionPlaying",
            "Audio:  interruptionRecording"]
        return audioNames[rawValue]
    }
    
    
    //  CustomStringConvertible
    var description: String {
        return audioName
    }
}
