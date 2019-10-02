//
//  ViewController.swift
//  First
//
//  Created by dengjiangzhou on 2018/6/4.
//  Copyright © 2018年 dengjiangzhou. All rights reserved.
//

import UIKit

import AVFoundation



class ViewController: UIViewController {
    
    @IBOutlet weak var penguin: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioStatus: AudioStatus = AudioStatus.stopped
    
    var audioRecorder: AVAudioRecorder!
    // 一个 音频 录制
    
    var audioPlayer: AVAudioPlayer!
    // 一个 音频 播放
    
    var soundTimer: CFTimeInterval = 0.0
    var updateTimer: CADisplayLink!
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    
    // MARK: - IBAction:   Controls
    @IBAction func onRecord(_ sender: UIButton) {
    
        if appHasMicAccess == true {
            switch audioStatus {
            case .stopped:
                recordButton.setBackgroundImage(UIImage(named: "button-record1"), for: UIControl.State.normal )
                record()
            case .recording:
                recordButton.setBackgroundImage(UIImage(named: "button-record"), for: UIControl.State.normal )
                stopRecording()
            case .playing:
                stopPlayback()
            default:
                ()
            }
            
        }// if appHasMicAccess == true
        else {
            // 里面的 代码， 不做考虑
            recordButton.isEnabled = false
            let theAlert = UIAlertController(title: "Requires Microphone Access",
                                             message: "Go to Settings > PenguinPet > Allow PenguinPet to Access Microphone.\nSet switch to enable.",
                                             preferredStyle: UIAlertController.Style.alert)
            
            theAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.view?.window?.rootViewController?.present(theAlert, animated: true, completion: {            })
            
        }
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        switch audioStatus {
        case .recording:
            recordButton.setBackgroundImage(UIImage(named: "button-record"), for: UIControl.State.normal )
            stopRecording()
        case .stopped:
            play()
        case .playing:
            stopPlayback()
        default:
            ()
        }
    }
    
    func setPlayButtonOn(flag: Bool) {
        if flag == true {
            playButton.setBackgroundImage(UIImage(named: "button-play1"), for: UIControl.State.normal )
        } else {
            playButton.setBackgroundImage(UIImage(named: "button-play"), for: UIControl.State.normal )
        }
    }
    
    
}

// MARK: - AVFoundation Methods
extension ViewController{
    
    // MARK: Recording
    func setupRecorder() {
        let fileURL = getURLforMemo()
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any]
        
        do {
            audioRecorder =  try AVAudioRecorder(url: fileURL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print("Error creating audio Recorder.")
        }
        
    }
    
    func record() {
        startUpdateLoop()
        audioStatus = .recording
        audioRecorder.record()
    }
    
    
    func stopRecording() {
        recordButton.setBackgroundImage(UIImage(named: "button-record"), for: UIControl.State.normal  )
        audioStatus = .stopped
        audioRecorder.stop()
        stopUpdateLoop()
    }
    
    // MARK: Playback
    func play() {
        let fileURL = getURLforMemo()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = self
            if audioPlayer.duration > 0.0 {
                setPlayButtonOn(flag: true)
                audioPlayer.play()
                audioStatus = .playing
                
                startUpdateLoop()
            }
            
        } catch {
            print("Error loading audio Player")
        }
    }
    
    func stopPlayback() {
        setPlayButtonOn(flag: false)
        audioStatus = .stopped
        audioPlayer.stop()
        stopUpdateLoop()
    }  //  停止 回放 功能
    
}


extension ViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    // MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        audioStatus = .stopped
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        setPlayButtonOn(flag: false)
        audioStatus = .stopped
        stopUpdateLoop()
    }

    // MARK: - Helpers
    
    func getURLforMemo() -> URL {
        let tempDir = NSTemporaryDirectory()
        let filePath = tempDir + "/TempMemo.caf"
        return URL(fileURLWithPath: filePath)
    }
 
    func formattedCurrentTime(_ time: UInt) -> String{
        let hours = time / 3600
        let minutes = ( time / 60 ) % 60
        let seconds = time % 60
        
        return String(format: "%02i: %02i: %02i", hours, minutes, seconds)
    }
}


// MARK:- Timer

extension ViewController{

    // MARK:- Update Loop
    func startUpdateLoop(){
        if updateTimer != nil{
            updateTimer.invalidate()
        }
        updateTimer = CADisplayLink(target: self, selector: #selector(ViewController.updateLoop))
        updateTimer.preferredFramesPerSecond = 1
        updateTimer.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }

    
    @objc func updateLoop(){
        if audioStatus == .recording{
            if CFAbsoluteTimeGetCurrent() - soundTimer > 0.5 {
                timeLabel.text = formattedCurrentTime(UInt(audioRecorder.currentTime))
                soundTimer = CFAbsoluteTimeGetCurrent()
            }
        }
        else if audioStatus == .playing{
            if CFAbsoluteTimeGetCurrent() - soundTimer > 0.5 {
                timeLabel.text = formattedCurrentTime(UInt(audioPlayer.currentTime))
                soundTimer = CFAbsoluteTimeGetCurrent()
            }
        }
    }

    func stopUpdateLoop(){
        updateTimer.invalidate()
        updateTimer = nil
        timeLabel.text = formattedCurrentTime(UInt(0))
    }
}
