//
//  Reader+Converter.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 1/7/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import os.log

// MARK: - Errors



// MARK: -

func ReaderConverterCallback(_ converter: AudioConverterRef,
                             _ packetCount: UnsafeMutablePointer<UInt32>,
                             _ ioData: UnsafeMutablePointer<AudioBufferList>,
                             _ outPacketDescriptions: UnsafeMutablePointer<UnsafeMutablePointer<AudioStreamPacketDescription>?>?,
                             _ context: UnsafeMutableRawPointer?) -> OSStatus {
    let reader = Unmanaged<Reader>.fromOpaque(context!).takeUnretainedValue()
    
    //
    // Make sure we have a valid source format so we know the data format of the parser's audio packets
    //
    guard let _ = reader.dataFormatD else {
        return ReaderMissingSourceFormatError
    }
    
    //
    // Check if we've reached the end of the packets. We have two scenarios:
    //     1. We've reached the end of the packet data and the file has been completely parsed
    //     2. We've reached the end of the data we currently have downloaded, but not the file
    //
    let packetIndex = Int(reader.currentPacket)
    let packets = reader.packetsX
    let isEndOfData = packetIndex >= packets.count - 1
    if isEndOfData {
        
        packetCount.pointee = 0
        return ReaderReachedEndOfDataError
        
    }
    
    //
    // Copy data over (note we've only processing a single packet of data at a time)
    //
    let data = packets[packetIndex]
    let dataCount = data.count
    // print("dataCount = \(dataCount)")
    
    
    ioData.pointee.mNumberBuffers = 1
    ioData.pointee.mBuffers.mData = UnsafeMutableRawPointer.allocate(byteCount: dataCount, alignment: 0)
    
    data.withUnsafeBytes { (rawBufferPointer) in
        let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
        if let address = bufferPointer.baseAddress{
            memcpy((ioData.pointee.mBuffers.mData?.assumingMemoryBound(to: UInt8.self))!, address, dataCount)
        }
    }
    ioData.pointee.mBuffers.mDataByteSize = UInt32(dataCount)
    
    packetCount.pointee = 1
    reader.currentPacket = reader.currentPacket + 1
    
    return noErr
}
