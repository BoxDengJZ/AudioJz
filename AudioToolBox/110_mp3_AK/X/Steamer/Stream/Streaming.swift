//
//  Streaming.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 6/5/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation

/// The `Streaming` protocol provides an interface for defining the behavior we expect of an `AVAudioEngine`-based streamer. In this protocol we assume we're pulling the audio data from a remote URL on the internet, but could modify it to support loading audio data from any arbitrary source. We use the `downloader` property to describe a concrete class we expect to download the audio's binary data. Then we use the `parser` property to describe a concrete class we expect to parse the audio's binary data into audio packets in the audio's native format (could be compressed like MP3, AAC, etc). We finally use the `reader` property to describe a concrete class we expect to provide LPCM audio packets to the `playerNode` to schedule for playback in the `engine`. The `reader` pulls audio data from the parser's packets and converts it into the target LPCM format. In addition, in this protocol we provide playback related properties such as `currentTime`, `duration`, and `state` as well as a `delegate` adhering to the `StreamingDelegate` to provide a caller updates when properties change. 
public protocol Streaming: class {
    
    // MARK: - Properties
    
    /// A `TimeInterval` representing the current play time
    var currentTime: TimeInterval { get }
    
    /// A `StreamingDelegate` to handle events from a `Streaming`
    var delegate: StreamingDelegate? { get set }
    
    /// A `TimeInterval` representing the total duration
    var duration: TimeInterval? { get }
    
    /// An `AVAudioEngine` used for playback
    var engine: AVAudioEngine { get }
    
    /// An `AVAudioPlayerNode` used to schedule the LPCM audio buffers
    var playerNode: AVAudioPlayerNode { get }
    
    /// An `AVAudioFrameCount` representing the number of frames that should be read from the `reader` and scheduled into the `playerNode`. Default value is 8192
    var readBufferSize: AVAudioFrameCount { get }
    
    /// An `AVAudioFormat` representing a LPCM format that the `reader` will provide audio as. The connections on the `engine` should be set using this format. Default is a non-interleaved, 32-bit float, stereo (2 channel), 44.1 kHz sample rate.
    var readFormat: AVAudioFormat { get }
    
    /// A `StreamingState` indicating the current status of a streamer.
    var stateDeng: StreamingState { get }
    
    /// A `URL` representing the current remote resource being streamed.
    var sourceURL: URL? { get }
    
    
    
    
    
    
    
    
    
    
    /// A `Float` representing the volume of the main mixer on the `engine`
    var volume: Float { get set }
    
    // MARK: - Methods
    
    /// Begins playback
    func playS()
    
    /// Pauses playback
    func pauseS()
    
    /// Stops playback and any ongoing downloads.
    func stopDng()
    

    
}

extension Streaming {
    //  buffer size , 选用 4 k
    //  采用 32 KB 也可以
    public var readBufferSize: AVAudioFrameCount {
        4096
    }
    
    public var readFormat: AVAudioFormat {
        return AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 2, interleaved: false)!
    }
    
    
    
    
}
