//
//  Parser.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 1/6/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation

import AudioToolbox



// 就是看数据

import os.log

/// The `Parser` is a concrete implementation of the `Parsing` protocol used to convert binary data into audio packet data. This class uses the Audio File Stream Services to progressively parse the properties and packets of the incoming audio data.
public class Parser{
    static let logger = OSLog(subsystem: "com.fastlearner.streamer", category: "Parser")
    static let loggerPacketCallback = OSLog(subsystem: "com.fastlearner.streamer", category: "Parser.Packets")
    static let loggerPropertyListenerCallback = OSLog(subsystem: "com.fastlearner.streamer", category: "Parser.PropertyListener")
    
    // MARK: - Parsing props
    
    public internal(set) var dataFormatD: AVAudioFormat?
    public internal(set) var packetsX = [Data]()
  
    
    // MARK: - Properties
    
    /// A `UInt64` corresponding to the total frame count parsed by the Audio File Stream Services
    public internal(set) var frameCount: UInt64 = 0
    
    // 把一个文件，弄成一个 ID, 拿这个 ID , 去处理事情
    
    // 一个文件，对应一个AudioFileStreamID
    
    public var totalPacketCount: AVAudioPacketCount? {
        guard let _ = dataFormatD else {
            return nil
        }
        
        return AVAudioPacketCount(packetsX.count)
    }
    
    var playbackFile: AudioFileID?

    
    // MARK: - Methods
    
    public func parse(url src: URL) throws {
        Utility.check(error:  AudioFileOpenURL(src as CFURL, .readPermission, 0,  &playbackFile),  operation: "AudioFileOpenURL failed")
        
        guard let file = playbackFile else {
            return
        }
        
        var numPacketsToRead: UInt32 = 0
        
        
        GetPropertyValue(val: &numPacketsToRead, file: file, prop: kAudioFilePropertyAudioDataPacketCount)
        
        var asbdFormat = AudioStreamBasicDescription()
        GetPropertyValue(val: &asbdFormat, file: file, prop: kAudioFilePropertyDataFormat)
        
        dataFormatD = AVAudioFormat(streamDescription: &asbdFormat)
        /// At this point we should definitely have a data format
        var bytesRead: UInt32 = 0
        GetPropertyValue(val: &bytesRead, file: file, prop: kAudioFilePropertyAudioDataByteCount)
        
        guard let dataFormat = dataFormatD else {
            return
        }
        
        let format = dataFormat.streamDescription.pointee
        let bytesPerPacket = Int(format.mBytesPerPacket)
        
        var one: UInt32 = 1
        var position: Int64 = 0
        while true{
            
            var data = UnsafeMutableRawPointer.allocate(byteCount: 2, alignment: 0)
            var packetDescs: UnsafeMutablePointer<AudioStreamPacketDescription>?
            // read audio data from file into supplied buffer
            var numBytes: UInt32 = 0

            Utility.check(error: AudioFileReadPacketData(playbackFile!,              // AudioFileID
                                                         false,                                     // use cache?
                                                         &numBytes,                                 // initially - buffer capacity, after - bytes actually read
                                                         packetDescs,                // pointer to an array of PacketDescriptors
                                                         position,             // index of first packet to be read
                                                         &one,                                 // number of packets
                                                         data),          // output buffer
                          operation: "AudioFileReadPacketData failed")

            // enqueue buffer into the Audio Queue
            // if nPackets == 0 it means we are EOF (all data has been read from file)
            if one > 0 {
                position += Int64(one)
                
            let packetStart = Int64(i * bytesPerPacket)
            let dataPt: UnsafeMutableRawPointer = malloc(MemoryLayout<UInt8>.size * bytesPerPacket)
            AudioFileReadBytes(file, false, packetStart, &packetSize, dataPt)
            let startPt = dataPt.bindMemory(to: UInt8.self, capacity: bytesPerPacket)
            let buffer = UnsafeBufferPointer(start: startPt, count: bytesPerPacket)
            let array = Array(buffer)
            packetsX.append(Data(array))
        }
   
    }

    
    
    func over(){
        if playbackFile != nil{
            AudioFileClose(playbackFile!)
        }
       
    }
    
}


extension Parser{
    
    
    public var duration: TimeInterval? {
        guard let sampleRate = dataFormatD?.sampleRate else {
            return nil
        }
        
        guard let totalFrameCount = totalFrameCount else {
            return nil
        }
        
        return TimeInterval(totalFrameCount) / TimeInterval(sampleRate)
    }
    

    
    public var totalFrameCount: AVAudioFrameCount? {
        guard let framesPerPacket = dataFormatD?.streamDescription.pointee.mFramesPerPacket else {
            return nil
        }
        
        guard let totalPacketCount = totalPacketCount else {
            return nil
        }
        
        return AVAudioFrameCount(totalPacketCount) * AVAudioFrameCount(framesPerPacket)
    }
    
    public func frameOffset(forTime time: TimeInterval) -> AVAudioFramePosition? {
        guard let _ = dataFormatD?.streamDescription.pointee,
            let frameCount = totalFrameCount,
            let duration = duration else {
                return nil
        }
        
        let ratio = time / duration
        return AVAudioFramePosition(Double(frameCount) * ratio)
    }
    
    public func packetOffset(forFrame frame: AVAudioFramePosition) -> AVAudioPacketCount? {
        guard let framesPerPacket = dataFormatD?.streamDescription.pointee.mFramesPerPacket else {
            return nil
        }
        
        return AVAudioPacketCount(frame) / AVAudioPacketCount(framesPerPacket)
    }
    
    public func timeOffset(forFrame frame: AVAudioFrameCount) -> TimeInterval? {
        guard let _ = dataFormatD?.streamDescription.pointee,
            let frameCount = totalFrameCount,
            let duration = duration else {
                return nil
        }
        
        return TimeInterval(frame) / TimeInterval(frameCount) * duration
    }
}





func GetPropertyValue<T>(val value: inout T, file f: AudioFileID, prop propertyID: AudioFilePropertyID) {
    var propSize: UInt32 = 0
    guard AudioFileGetPropertyInfo(f, propertyID, &propSize, nil) == noErr else {
 
        return
    }
    
    guard AudioFileGetProperty(f, propertyID, &propSize, &value) == noErr else {
        
        return
    }
}





class Utility {
    //
    // convert a Core Audio error code to a printable string
    //
    static func codeToString(_ error: OSStatus) -> String {
        
        // byte swap the error
        let errorCode = CFSwapInt32HostToBig(UInt32(bitPattern: error))

        // separate the UInt32 into 4 bytes
        var bytes = [UInt8](repeating: 0, count: 4)
        bytes[0] = UInt8(errorCode & 0x000000ff)
        bytes[1] = UInt8( (errorCode & 0x0000ff00) >> 8)
        bytes[2] = UInt8( (errorCode & 0x00ff0000) >> 16)
        bytes[3] = UInt8( (errorCode & 0xff000000) >> 24)
        
        // do the four bytes all represent printable characters?
        if isprint(Int32(bytes[0])) != 0 && isprint(Int32(bytes[1])) != 0 &&
            isprint(Int32(bytes[2])) != 0 && isprint(Int32(bytes[3])) != 0 {
            
            // YES, return a String made from them
            return String(bytes: bytes, encoding: String.Encoding.ascii)!
        
        } else {
            
            // NO, treat the UInt32 as a number and create a String of the number
            return String(format: "%d", error)
        }
    }
    //
    // generic error handler - if error is nonzero, prints error message and exits program.
    //
    static func check(error: OSStatus , operation: String) {
    
        // return if no error
        if error == noErr { return }
        print(error)
        // print either four characters or the numeric value
        Swift.print("Error: \(operation), returned: \(codeToString(error))")
        
        // terminate the program
        exit(1)
    }
    //
    // Copy a file's magic cookie to a queue
    //
    static func applyEncoderCookie(fromFile file: AudioFileID, toQueue queue: AudioQueueRef) {
        var propertySize: UInt32 = 0
        
        // get the magic cookie, if any, from the file
        let result = AudioFileGetPropertyInfo (file, kAudioFilePropertyMagicCookieData, &propertySize, nil)

        // is there a cookie?
        if result == noErr && propertySize > 0 {
            
            // YES, allocate space for it
            let magicCookie: UnsafeMutableRawPointer  = malloc(4)

            // get the cookie
            Utility.check(error: AudioFileGetProperty (file,
                                                       kAudioFilePropertyMagicCookieData,
                                                       &propertySize,
                                                       magicCookie),
                          operation: "get cookie from file failed");
            
            // now set the magic cookie on the queue
            Utility.check(error: AudioQueueSetProperty(queue,
                                                       kAudioQueueProperty_MagicCookie,
                                                       magicCookie,
                                                       propertySize),
                          operation: "set cookie on queue failed");

            // release the malloc'd memory
            free(magicCookie);
        }
    }

}







