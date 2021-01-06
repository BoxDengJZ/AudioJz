//
//  ViewController.swift
//  TimePitchStreamer
//
//  Created by Syed Haris Ali on 1/7/18.
//  Copyright © 2018 Ausome Apps LLC. All rights reserved.
//

import UIKit
import AVFoundation
import os.log



import MediaPlayer



class ViewController: UIViewController {
    static let logger = OSLog(subsystem: "com.fastlearner.streamer", category: "ViewController")
    
    
    // UI props
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var pitchSlider: UISlider!
    
    
    @IBOutlet weak var cycleBtn: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressSlider: ProgressSlider!
    
    
    
    var cycleMode: ( titles: [String], tick: Bool) = (["默认关闭", "打开了"], false)
    
    var length: TimeInterval?
    
    // Streamer props
    lazy var streamer: TimePitchStreamer = {
        let streamer = TimePitchStreamer()
        streamer.delegate = self
        return streamer
    }()
    
    // Used so we can use the current time slider continuously, but only seek when the user touches up
    var isSeeking = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCycleMode()
        
        
        // Setup the AVAudioSession and AVAudioEngine
        setupAudioSession()
        
        // Reset the pitch and rate
        resetPitch(self)
        resetRate(self)
        
        /// Download
        let url = URL(string: "http://aod.cos.tx.xmcdn.com/group31/M0B/BB/58/wKgJSVmSRjvCZ4wwAAugz-tllHw858.m4a")!
        streamer.url = url
        
        
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
    }
    
    
    
    
    
    
    // MARK: - Setting Up The Engine
    
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, policy: .default, options: [.allowBluetoothA2DP,.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            os_log("Failed to activate audio session: %@", log: ViewController.logger, type: .default, #function, #line, error.localizedDescription)
        }
    }

    // MARK: - Playback
    
    @IBAction func togglePlayback(_ sender: UIButton) {
        os_log("%@ - %d", log: ViewController.logger, type: .debug, #function, #line)
        
        if streamer.state == .playing {
            streamer.pause()
            
        } else {
            streamer.play()
        }
    }
    
    /// MARK: - Handle Seeking
    
    @IBAction func seek(_ sender: UISlider) {
        os_log("%@ - %d [%.1f]", log: ViewController.logger, type: .debug, #function, #line, progressSlider.value)
        
        do {
            let time = TimeInterval(progressSlider.value)
            try streamer.seek(to: time)
        } catch {
            os_log("Failed to seek: %@", log: ViewController.logger, type: .error, error.localizedDescription)
        }
    }
    
    @IBAction func progressSliderTouchedDown(_ sender: UISlider) {
        os_log("%@ - %d", log: ViewController.logger, type: .debug, #function, #line)
        
        isSeeking = true
    }
    
    @IBAction func progressSliderValueChanged(_ sender: UISlider) {
        os_log("%@ - %d", log: ViewController.logger, type: .debug, #function, #line)
        
        let currentTime = TimeInterval(progressSlider.value)
        currentTimeLabel.text = currentTime.toMMSS()
    }
    
    @IBAction func progressSliderTouchedUp(_ sender: UISlider) {
        os_log("%@ - %d", log: ViewController.logger, type: .debug, #function, #line)
        
        seek(sender)
        isSeeking = false
    }
    
    /// MARK: - Change Pitch
    
    @IBAction func changePitch(_ sender: UISlider) {
        os_log("%@ - %d [%.1f]", log: ViewController.logger, type: .debug, #function, #line, sender.value)
        
        let step: Float = 100
        var pitch = roundf(pitchSlider.value)
        let newStep = roundf(pitch / step)
        pitch = newStep * step
        streamer.pitch = pitch
        pitchSlider.value = pitch
        pitchLabel.text = String(format: "%i cents", Int(pitch))
    }
    
    @IBAction func resetPitch(_ sender: Any) {
        os_log("%@ - %d [%.1f]", log: ViewController.logger, type: .debug, #function, #line)
        
        let pitch: Float = 0
        streamer.pitch = pitch
        pitchLabel.text = String(format: "%i cents", Int(pitch))
        pitchSlider.value = pitch
    }
    
    /// MARK: - Change Rate
    
    @IBAction func changeRate(_ sender: UISlider) {
        os_log("%@ - %d [%.1f]", log: ViewController.logger, type: .debug, #function, #line, sender.value)
        
        let step: Float = 0.25
        var rate = rateSlider.value
        let newStep = roundf(rate / step)
        rate = newStep * step
        streamer.rate = rate
        rateSlider.value = rate
        rateLabel.text = String(format: "%.2fx", rate)
    }
    
    @IBAction func resetRate(_ sender: Any) {
        os_log("%@ - %d [%.1f]", log: ViewController.logger, type: .debug, #function, #line)
        
        let rate: Float = 1
        streamer.rate = rate
        rateLabel.text = String(format: "%.2fx", rate)
        rateSlider.value = rate
    }
    
}




extension ViewController{
    
    
    
    
    func addCycleMode(){
        
        cycleBtn.setTitle(cycleMode.titles[0], for: UIControl.State.normal)
        cycleBtn.addTarget(self, action: #selector(ViewController.cycle), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc func cycle(){
        if cycleMode.tick{
            cycleBtn.setTitle(cycleMode.titles[0], for: UIControl.State.normal)
        }
        else{
            cycleBtn.setTitle(cycleMode.titles[1], for: UIControl.State.normal)
        }
        cycleMode.tick.toggle()
        streamer.repeats.toggle()
    }
    
    
    func show(mediaInfo time: TimeInterval){
        let artistName = "test"
        
        guard let duration = length else {
            return
        }
        var isPlaying: Double = 0
        
        var pInfo: [String: Any] = [MPMediaItemPropertyArtist : artistName,
                                    MPMediaItemPropertyTitle : artistName ]
        if let img = UIImage(systemName: "music.note.list"){
            let artwork = MPMediaItemArtwork(boundsSize: img.size, requestHandler: {  (_) -> UIImage in
                return img
            })
            pInfo[MPMediaItemPropertyArtwork] = artwork
            
        }
        
        if streamer.state == .playing{
            isPlaying = 1
            pInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
            pInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }
        pInfo[MPMediaItemPropertyPersistentID] = artistName
        pInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(floatLiteral: isPlaying)
        pInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = NSNumber(floatLiteral: isPlaying)
        pInfo[MPNowPlayingInfoPropertyMediaType] = NSNumber(value: MPNowPlayingInfoMediaType.audio.rawValue)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = pInfo
    }
}
