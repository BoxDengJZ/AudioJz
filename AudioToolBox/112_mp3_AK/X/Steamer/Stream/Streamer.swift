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

    public let engine = AVAudioEngine()
    public let playerNode = AVAudioPlayerNode()
    
    
    let timePitchNode: AVAudioUnitTimePitch = {
        let t = AVAudioUnitTimePitch()
        t.rate = 0.9
        return t
    }()
    
    
    public internal(set) var stateDeng: StreamingState = .stopped {
        didSet {
            delegate?.streamer(dng: self, changedState: stateDeng)
        }
    }
    
    
    var shutUp = AudioRecord()
    
    
    public var sourceURL: URL? {
        didSet {
           

    
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
           
            self?.notifyTimeUpdated()
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    /// Subclass can override this to attach additional nodes to the engine before it is prepared. Default implementation attaches the `playerNode`. Subclass should call super or be sure to attach the playerNode.
    open func attachNodes() {
        engine.attach(playerNode)
        engine.attach(timePitchNode)
    }

    /// Subclass can override this to make custom node connections in the engine before it is prepared. Default implementation connects the playerNode to the mainMixerNode on the `AVAudioEngine` using the default `readFormat`. Subclass should use the `readFormat` property when connecting nodes.
    open func connectNodes() {
        engine.connect(playerNode, to: timePitchNode, format: readFormat)
        engine.connect(timePitchNode, to: engine.mainMixerNode, format: readFormat)
    }
    
    // MARK: - Reset
    

    
    // MARK: - Methods
    
    public func playS() {
        os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
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
        os_log("%@ - %d", log: Streamer.logger, type: .debug, #function, #line)
        
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
       

//        do {
//            let nextScheduledBuffer = try reader.read(readBufferSize)
//    
//            // 这个方法，很有意思，timer 给他塞的 buffer, 比他自己消费的速度， 快多了
//            playerNode.scheduleBuffer(nextScheduledBuffer)
//        } catch {
//            os_log("Cannot schedule buffer: %@", log: Streamer.logger, type: .debug, error.localizedDescription)
//        }
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
          shutUp.currentX = max(0, i - 1)
      }
    
}




// 计算 音频分配 buffer, 累计时间长度

