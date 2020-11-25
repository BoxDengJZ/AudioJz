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

    
    for i in 0 ..< Int(packetCount) {
        let packetStart = i * bytesPerPacket
        let packetSize = bytesPerPacket

        let packetData = Data(bytes: data.advanced(by: packetStart), count: packetSize)

        parser.packetsX.append(packetData)
    }
    
}
