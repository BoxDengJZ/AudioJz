//
//  Utils.swift
//  Sound Butler
//
//  Created by Michael Briscoe on 12/14/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation

var appHasMicAccess = false

enum AudioStatus: Int, CustomStringConvertible {
  case stopped = 0, playing, paused
  
  var audioName: String {
    let audioNames = [
      "Audio: Stopped",
      "Audio:Playing",
      "Audio:Paused"]
    return audioNames[rawValue]
  }
  
  var description: String {
    return audioName
  }
}
