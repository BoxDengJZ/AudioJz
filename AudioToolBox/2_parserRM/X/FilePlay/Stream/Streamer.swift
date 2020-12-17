//
//  Streamer.swift
//  AudioStreamer
//
//  Created by Syed Haris Ali on 6/5/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import AVFoundation
import Foundation
import os.log






/// The `Streamer` is a concrete implementation of the `Streaming` protocol and is intended to provide a high-level, extendable class for streaming an audio file living at a URL on the internet. Subclasses can override the `attachNodes` and `connectNodes` methods to insert custom effects.




open class Streamer: Streaming {
    
    let timeNode: [TimeInterval]
    
    
    var firstPause = false
    
    
    
    static let logger = OSLog(subsystem: "com.fastlearner.streamer", category: "Streamer")

    // MARK: - Properties (Streaming)
    
    public var currentTime: TimeInterval{
        guard let nodeTime = playerNode.lastRenderTime,
            let playerTime = playerNode.playerTime(forNodeTime: nodeTime) else {
            return currentTimeOffset
        }
        let currentTime = TimeInterval(playerTime.sampleTime) / playerTime.sampleRate
        return currentTime + currentTimeOffset
    }
    
    
    
    public var delegate: StreamingDelegate?
    public internal(set) var duration: TimeInterval?
    
    public internal(set) var reader_ha: Reader?

    public let engine = AVAudioEngine()
    public let playerNode = AVAudioPlayerNode()
    public internal(set) var stateDeng: StreamingState = .stopped {
        didSet {
            delegate?.streamer(dng: self, changedState: stateDeng)
        }
    }
    
    
    var repeatControl = AudioRecord()
    
    
    public var sourceURL: URL? {
        didSet {
            resetDng()

            if let src = sourceURL{
                load(src: src)
            }
        }
    }
    
    
    
    
    
    
    public var volume: Float {
        get {
            engine.mainMixerNode.outputVolume
        }
        set {
            engine.mainMixerNode.outputVolume = newValue
        }
    }
    var volumeRampTimer: Timer?
    var volumeRampTargetValue: Float = 1

    // MARK: - Properties
    
    /// A `TimeInterval` used to calculate the current play time relative to a seek operation.
    var currentTimeOffset: TimeInterval = 0
    
    /// A `Bool` indicating whether the file has been completely scheduled into the player node.
    var isFileSchedulingComplete = false

    
    let kk: String
    
    // MARK: - Lifecycle
    
    public init(source src: String, with nodes: [TimeInterval], bridge proxy: StreamingDelegate) {
        // Setup the audio engine (attach nodes, connect stuff, etc). No playback yet.
        // Create a new parser
        kk = src
        timeNode = nodes
        delegate = proxy
     
        setupAudioEngine()
        
    }

    // MARK: - Setup

    func setupAudioEngine() {
        os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)

        // Attach nodes
        attachNodes()

        // Node nodes
        connectNodes()

        // Prepare the engine
        engine.prepare()
        
        /// Use timer to schedule the buffers (this is not ideal, wish AVAudioEngine provided a pull-model for scheduling buffers)
        let timer = Timer(timeInterval: intervalD, repeats: true) {
            [weak self] _ in
            guard self?.stateDeng != .stopped else {
                return
            }
            
            self?.scheduleNextBuffer()
            self?.handleTimeUpdate()
            self?.notifyTimeUpdated()
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    /// Subclass can override this to attach additional nodes to the engine before it is prepared. Default implementation attaches the `playerNode`. Subclass should call super or be sure to attach the playerNode.
    open func attachNodes() {
        engine.attach(playerNode)
    }

    /// Subclass can override this to make custom node connections in the engine before it is prepared. Default implementation connects the playerNode to the mainMixerNode on the `AVAudioEngine` using the default `readFormat`. Subclass should use the `readFormat` property when connecting nodes.
    open func connectNodes() {
        engine.connect(playerNode, to: engine.mainMixerNode, format: readFormat)
    }
    
    // MARK: - Reset
    
    func resetDng(){
        os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
        // Reset the playback state
        stopDng()
        reader_ha?.over()
        duration = nil
        reader_ha = nil
        isFileSchedulingComplete = false
        
        
    }
    
    // MARK: - Methods
    
    public func playS() {
    //    os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
        // Check we're not already playing
        guard !playerNode.isPlaying else {
            return
        }
        
        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                os_log("Failed to start engine: %@", log: Streamer.logger, type: .error, error.localizedDescription)
            }
        }
        
        // To make the volume change less harsh we mute the output volume
        volume = 0
        
        // Start playback on the player node
        playerNode.play()
        
        // After 250ms we restore the volume to where it was
        swellVolume()
        
        // Update the state
        stateDeng = .playing
    }
    
    public func pauseS() {
      //  os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
        // Check if the player node is playing
        guard playerNode.isPlaying else {
            return
        }
        volume = 0
        // Pause the player node and the engine
        playerNode.pause()
        
        // Update the state
        stateDeng = .paused
    }
    
    public func stopDng() {
        os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
        // Stop the downloader, the player node, and the engine
   
        playerNode.stop()
        engine.stop()
        
        // Update the state
        stateDeng = .stopped
    }
    
    
    
    
    
    
    
    
    public
    func seek(to time: TimeInterval) throws {
        os_log("%@ - %d [%.1f]", log: Streamer.logger, type: .debug, #function, #line, time)
        
        // Make sure we have a valid parser and reader
        guard let reader = reader_ha, let ratio = reader.ratio(forTime: time) else {
            return
        }
        
        currentTimeOffset = time
        isFileSchedulingComplete = false
        
        // We need to store whether or not the player node is currently playing to properly resume playback after
        let isPlaying = playerNode.isPlaying
        
        // Stop the player node to reset the time offset to 0
        
        
        // 栈，排空
        playerNode.stop()
        volume = 0
        
        // Perform the seek to the proper packet offset
        do {
            try reader.seek(buffer: ratio)
        } catch {
            os_log("Failed to seek: %@", log: Streamer.logger, type: .error, error.localizedDescription)
            return
        }
        
        // If the player node was previous playing then resume playback
        if isPlaying {
            playerNode.play()
        }
        
        // Update the current time
        delegate?.streamer(fire: self, updatedCurrentTime: time)
        
        swellVolume()
    }
    
    
    
    
    func swellVolume(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(60)) { [unowned self] in
            self.volumeRampTimer?.invalidate()
            let timer = Timer(timeInterval: Double( 0.25 / (self.volumeRampTargetValue * 10)), repeats: true) { timer in
                if self.volume != self.volumeRampTargetValue {
                    self.volume = self.volumeRampTargetValue
                } else {
                    self.volumeRampTimer = nil
                    timer.invalidate()
                }
            }
            RunLoop.current.add(timer, forMode: .common)
            self.volumeRampTimer = timer
        }
    }

    
    
    
    
    // MARK: - Scheduling Buffers

    func scheduleNextBuffer() {
        guard let reader = reader_ha else {
            os_log("No reader yet...", log: Streamer.logger, type: .debug)
            return
        }

        
        guard repeatControl.pauseWork == false else {
            if firstPause == false, Date().timeIntervalSince(repeatControl.currentMoment) >= repeatControl.stdPauseT{
                
                playS()
                repeatControl.pauseWork = false
            }
            
            return
        }

        var shouldReturn = false
        
        let i = repeatControl.currentX
        let count = timeNode.count
        
        
        if repeatControl.toClimb{

            if repeatControl.howManyNow < repeatControl.countStdRepeat{
                if i < count, currentTime > timeNode[i]{
                    repeatControl.howManyNow += 1
                    if i == 0{
                        try? seek(to: 0)
                    }
                    else{
                        try? seek(to: timeNode[i - 1])
                    }
                    shouldReturn = true
                }
            }
            else{
                repeatControl.toClimb = false
            }

        }
        else {

            if i < count, currentTime > timeNode[i]{
                repeatControl.doPause(at: i)
                pauseS()
                
                shouldReturn = true
            }
            
            
        }
        
        guard shouldReturn == false else {
            return
        }
        // 文件，读完了，就不要再继续调度了
        guard !isFileSchedulingComplete else {
            return
        }
        
        
        do {
            let nextScheduledBuffer = try reader.read()
    
            // 这个方法，很有意思，timer 给他塞的 buffer, 比他自己消费的速度， 快多了
            playerNode.scheduleBuffer(nextScheduledBuffer)
        } catch ReaderError.reachedEndOfFile {
            os_log("Scheduler reached end of file", log: Streamer.logger, type: .debug)
            isFileSchedulingComplete = true
        } catch {
            os_log("Cannot schedule buffer: %@", log: Streamer.logger, type: .debug, error.localizedDescription)
        }
    }

    // MARK: - Handling Time Updates
    
    /// Handles the duration value, explicitly checking if the duration is greater than the current value. For indeterminate streams we can accurately estimate the duration using the number of packets parsed and multiplying that by the number of frames per packet.
    func handleDurationUpdate() {
        if let newDuration = reader_ha?.duration {
            // Check if the duration is either nil or if it is greater than the previous duration
            var shouldUpdate = false
            if duration == nil {
                shouldUpdate = true
            } else if let oldDuration = duration, oldDuration < newDuration {
                shouldUpdate = true
            }
            
            // Update the duration value
            if shouldUpdate {
                self.duration = newDuration
                notifyDurationUpdate(newDuration)
            }
        }
    }
    
    /// Handles the current time relative to the duration to make sure current time does not exceed the duration
    func handleTimeUpdate() {
        guard let duration = duration else {
            return
        }

        if currentTime >= duration {
            try? seek(to: 0)
            stateDeng = .over
            // 弹奏完成
            pauseS()
            
        }
    }

 

    func notifyDurationUpdate(_ duration: TimeInterval) {
        guard let _ = sourceURL else {
            return
        }

        delegate?.streamer(self, updatedDuration: duration)
    }

    func notifyTimeUpdated() {
        guard engine.isRunning, playerNode.isPlaying else {
            return
        }

        delegate?.streamer(fire: self, updatedCurrentTime: currentTime)
    }
}






extension Streamer {
    
  

    
    public func load(src path: URL){
        os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
        /// Once there's enough data to start producing packets we can use the data format
        if reader_ha == nil{
            do {
                reader_ha = try Reader(src: path, readFormat: readFormat, bufferSize: readBufferSize)
            } catch {
                os_log("Failed to create reader: %@", log: Streamer.logger, type: .error, error.localizedDescription)
            }
        }
        
        /// Update the progress UI
        DispatchQueue.main.async {
            [weak self] in
            
            
            // Check if we have the duration
            self?.handleDurationUpdate()
        }
    }
    
    
    
    
    
    func climb(to time: TimeInterval){
        
        firstPause = false
        
        idx(for: time)
        
        try? seek(to: time)
        
        playS()
        
    }
}






extension Streamer {
    
    func idx(for time: TimeInterval){
          var i = 0
          let count = timeNode.count
          let current = time
        
           
          while i < count{
              if current > timeNode[i]{
                  i += 1
              }
              else{
                  break
              }
          }
          repeatControl.currentX = max(0, i - 1)
      }
    
}




// 计算 音频分配 buffer, 累计时间长度

