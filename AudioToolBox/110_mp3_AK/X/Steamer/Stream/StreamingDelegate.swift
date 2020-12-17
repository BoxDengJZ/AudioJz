//
//  StreamingDelegate.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 6/5/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import Foundation

/// The `StreamingDelegate` provides an interface for responding to changes to a `Streaming` instance. These include whenever the streamer state changes, when the download progress changes, as well as the current time and duration changes.
public protocol StreamingDelegate: class {

    
    func streamer(ok finalT: TimeInterval)
    
    
    /// Triggered when the playback `state` changes.
    ///
    /// - Parameters:
    ///   - streamer: The current `Streaming` instance
    ///   - state: A `StreamingState` representing the new state value.
    func streamer(dng streamer: Streaming, changedState state: StreamingState)
    
    /// Triggered when the current play time is updated.
    ///
    /// - Parameters:
    ///   - streamer: The current `Streaming` instance
    ///   - currentTime: A `TimeInterval` representing the new current time value.
    func streamer(fire streamer: Streaming, updatedCurrentTime current: TimeInterval)
    
    /// Triggered when the duration is updated.
    ///
    /// - Parameters:
    ///   - streamer: The current `Streaming` instance
    ///   - duration: A `TimeInterval` representing the new duration value.
    func streamer(_ streamer: Streaming, updatedDuration duration: TimeInterval)
    
}



// 播放出现杂音，因为声卡没有内容， 没有 buffer, 空播放
