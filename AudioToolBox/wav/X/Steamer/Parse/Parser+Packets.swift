//
//  Parser+Packets.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 1/6/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation
import os.log

func ParserPacketCallback(_ context: UnsafeMutableRawPointer, _ byteCount: UInt32, _ packetCount: UInt32, _ data: UnsafeRawPointer, _ packetDescriptions: Optional<UnsafeMutablePointer<AudioStreamPacketDescription>>) {
    let parser = Unmanaged<Parser>.fromOpaque(context).takeUnretainedValue()
    
    /// At this point we should definitely have a data format
    guard let dataFormat = parser.dataFormatD else {
        return
    }
    
   
    let format = dataFormat.streamDescription.pointee
    let bytesPerPacket = Int(format.mBytesPerPacket)
    
    print("Int(packetCount):     \(Int(packetCount))")
    //  405284
    
    for i in 0 ..< Int(packetCount) {
        let packetStart = i * bytesPerPacket
        let packetSize = bytesPerPacket
        // print("bytesPerPacket: \(bytesPerPacket)")
        
        //  bytesPerPacket: 2
        let packetData = Data(bytes: data.advanced(by: packetStart), count: packetSize)
    //    print("packetData .count : \(packetData.count)")
        
//print("packetData[0]: \(packetData[0])")
        
     //   print("packetData[1]: \(packetData[1])")
        
        
        
        
        parser.packetsX.append(packetData)
    }
    
}
