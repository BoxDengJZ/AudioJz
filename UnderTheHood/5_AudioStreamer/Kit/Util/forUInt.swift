//
//  forUInt.swift
//  TimePitchStreamer
//
//  Created by Jz D on 2020/3/1.
//  Copyright © 2020 Ausome Apps LLC. All rights reserved.
//

import Foundation



extension UInt32{

    var formatIdMeans: String {
        
        var x = [UInt8](repeating: 0, count: 4)
        x[0] = UInt8(self & 0x000000ff)
        x[1] = UInt8( (self & 0x0000ff00) >> 8)
        x[2] = UInt8( (self & 0x00ff0000) >> 16)
        x[3] = UInt8( (self & 0xff000000) >> 24)
        
        return String(bytes: x, encoding: String.Encoding.utf8)!
    }

}
