//
//  Reader.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 1/6/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation
import os.log

/// The `Reader` is a concrete implementation of the `Reading` protocol and is intended to provide the audio data provider for an `AVAudioEngine`. The `parser` property provides a `Parseable` that handles converting binary audio data into audio packets in whatever the original file's format was (MP3, AAC, WAV, etc). The reader handles converting the audio data coming from the parser to a LPCM format that can be used in the context of `AVAudioEngine` since the `AVAudioPlayerNode` requires we provide `AVAudioPCMBuffer` in the `scheduleBuffer` methods.
public class Reader{
    static let logger = OSLog(subsystem: "com.fastlearner.streamer", category: "Reader")
    static let loggerConverter = OSLog(subsystem: "com.fastlearner.streamer", category: "Reader.Converter")
    
    // MARK: - Reading props
    
    public internal(set) var currentPacket: AVAudioPacketCount = 0
    
    var currentBuffer = 0
    // MARK: - Parsing props
    
    public internal(set) var dataFormatD: AVAudioFormat?
    public internal(set) var packetsX = [Data]()
  
    
    // MARK: - Properties
    
    /// A `UInt64` corresponding to the total frame count parsed by the Audio File Stream Services
    public internal(set) var frameCount: UInt64 = 0
    
    // 把一个文件，弄成一个 ID, 拿这个 ID , 去处理事情
    
    // 一个文件，对应一个AudioFileStreamID
    
    public var totalPacketCount: AVAudioPacketCount? = nil
    
    var playbackFile: AudioFileID?
    
    
    
    public let readFormat: AVAudioFormat
    
    
    
    
    var buffers = [AVAudioPCMBuffer]()
    
    
    
    // MARK: - Properties
    
    /// An `AudioConverterRef` used to do the conversion from the source format of the `parser` (i.e. the `sourceFormat`) to the read destination (i.e. the `destinationFormat`). This is provided by the Audio Conversion Services (I prefer it to the `AVAudioConverter`)
    var converter: AudioConverterRef? = nil
    
    /// A `DispatchQueue` used to ensure any operations we do changing the current packet index is thread-safe
    
    // MARK: - Lifecycle
    
    let readBufferSize: AVAudioFrameCount
    
    
    deinit {
        guard AudioConverterDispose(converter!) == noErr else {
            os_log("Failed to dispose of audio converter", log: Reader.logger, type: .error)
            return
        }
    }
    
    public required init(src path: URL, readFormat readF: AVAudioFormat, bufferSize size: AVAudioFrameCount) throws {
        readFormat = readF
        readBufferSize = size
        Utility.check(error:  AudioFileOpenURL(path as CFURL, .readPermission, 0,  &playbackFile) ,                // set on output to the AudioFileID
                      operation: "AudioFileOpenURL failed")
        
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
        
        for i in 0 ..< Int(numPacketsToRead) {
            
            var packetSize = UInt32(bytesPerPacket)
                
            let packetStart = Int64(i * bytesPerPacket)
            let dataPt: UnsafeMutableRawPointer = malloc(MemoryLayout<UInt8>.size * bytesPerPacket)
            AudioFileReadBytes(file, false, packetStart, &packetSize, dataPt)
            let startPt = dataPt.bindMemory(to: UInt8.self, capacity: bytesPerPacket)
            let buffer = UnsafeBufferPointer(start: startPt, count: bytesPerPacket)
            let array = Array(buffer)
            packetsX.append(Data(array))
        }
        print("packetsX.count = \(packetsX.count)")
        let sourceFormat = dataFormat.streamDescription
        let commonFormat = readF.streamDescription
        let result = AudioConverterNew(sourceFormat, commonFormat, &converter)
        guard result == noErr else {
            throw ReaderError.unableToCreateConverter(result)
        }
        
        let framesPerPacket = readFormat.streamDescription.pointee.mFramesPerPacket
        var packets = readBufferSize / framesPerPacket
        
       // print("frames: \(frames)")
        
      //  print("framesPerPacket: \(framesPerPacket)")
        
        totalPacketCount = AVAudioPacketCount(packetsX.count)
        
        while true {
            /// Allocate a buffer to hold the target audio data in the Read format
            guard let buffer = AVAudioPCMBuffer(pcmFormat: readFormat, frameCapacity: readBufferSize) else {
                throw ReaderError.failedToCreatePCMBuffer
            }
            buffer.frameLength = readBufferSize
            
            // Try to read the frames from the parser
          
            let context = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
            let status = AudioConverterFillComplexBuffer(converter!, ReaderConverterCallback, context, &packets, buffer.mutableAudioBufferList, nil)
            guard status == noErr else {
                switch status {
                case ReaderMissingSourceFormatError:
                    print("parserMissingDataFormat")
                    throw ReaderError.parserMissingDataFormat
                case ReaderReachedEndOfDataError:
                    print("reachedEndOfFile: buffers.count = \(buffers.count)")
                    packetsX.removeAll()
                    return
                case ReaderNotEnoughDataError:
                    print("notEnoughData")
                    throw ReaderError.notEnoughData
                default:
                    print("converterFailed")
                    throw ReaderError.converterFailed(status)
                }
            }
            buffers.append(buffer)
        }
        
    }
    
    // MARK: - Methods
    
    public func read() throws -> AVAudioPCMBuffer {
        
        guard currentBuffer < buffers.count else {
            throw ReaderError.reachedEndOfFile
        }
        let buff = buffers[currentBuffer]
        
        currentBuffer += 1
        return buff
        
        
    }
    
    public func seek(buffer ratio: TimeInterval) throws {

        currentBuffer = Int(TimeInterval(buffers.count) * ratio)
    }





    
    
    func over(){
        if playbackFile != nil{
            AudioFileClose(playbackFile!)
        }
       
    }
    
}


extension Reader{
    
    
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
    
    
    func ratio(forTime time: TimeInterval) -> TimeInterval?{
        guard let _ = dataFormatD?.streamDescription.pointee,
            let duration = duration else {
                return nil
        }
        return time / duration
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







