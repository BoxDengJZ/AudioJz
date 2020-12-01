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
    
    public internal(set) var dataFormatD = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: true)!
    public internal(set) var packetsX = [Data]()
  
    
    // 把一个文件，弄成一个 ID, 拿这个 ID , 去处理事情
    
    // 一个文件，对应一个AudioFileStreamID
    
    public var totalPacketCount: AVAudioPacketCount{
        return AVAudioPacketCount(packetsX.count)
    }

    
    // MARK: - Methods
    
    public func parse(url src: URL) throws {
        
        
            do {
                let data = try Data(contentsOf: src)
                let array = data.withUnsafeBytes { (pt: UnsafeRawBufferPointer) -> [UInt8] in
                    let head = pt.bindMemory(to: UInt8.self)
                    if let addr = head.baseAddress{
                        let buffer = UnsafeBufferPointer(start: addr, count: data.count)
                        return Array(buffer)
                    }
                    else{
                        return []
                    }
                }
                let count = array.count
                guard count > 0 else {
                    return
                }
                
                for i in stride(from: 0, to: count, by: 2){
                    let arr: [UInt8] = [array[i], array[i + 1]]
                    packetsX.append(Data(arr))
                }
                
            } catch {
                print(error)
            }
            
            
        
   
   
    }


}


extension Parser{
    
    
    public var duration: TimeInterval {
        let sampleRate = dataFormatD.sampleRate
        
        return TimeInterval(totalFrameCount) / TimeInterval(sampleRate)
    }
    

    
    public var totalFrameCount: AVAudioFrameCount{
        let framesPerPacket = dataFormatD.streamDescription.pointee.mFramesPerPacket
        
        return AVAudioFrameCount(totalPacketCount) * AVAudioFrameCount(framesPerPacket)
    }
    
    public func frameOffset(forTime time: TimeInterval) -> AVAudioFramePosition? {
        let frameCount = totalFrameCount

        let ratio = time / duration
        return AVAudioFramePosition(Double(frameCount) * ratio)
    }
    
    public func packetOffset(forFrame frame: AVAudioFramePosition) -> AVAudioPacketCount? {
        let framesPerPacket = dataFormatD.streamDescription.pointee.mFramesPerPacket
        
        return AVAudioPacketCount(frame) / AVAudioPacketCount(framesPerPacket)
    }
    
    public func timeOffset(forFrame frame: AVAudioFrameCount) -> TimeInterval? {

        return TimeInterval(frame) / TimeInterval(totalFrameCount) * duration
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







