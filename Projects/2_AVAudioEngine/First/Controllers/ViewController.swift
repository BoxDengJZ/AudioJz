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
    
    
    // 一个音频录制
    var audioRecorder: AVAudioRecorder!
    
    // 一个音频播放
    var audioPlayer: AVAudioPlayer!
    
    var soundTimer: CFTimeInterval = 0.0
    var updateTimer: CADisplayLink!
    
    // MeterTable , 自己实现的
    let meterTable = MeterTable(tableSize: 100)
    
    
    let audioAVEngine = AVAudioEngine()
    var enginePlayer = AVAudioPlayerNode()
    
    let pitchEffect = AVAudioUnitTimePitch()
    let reverbEffect = AVAudioUnitReverb()
    let rateEffect = AVAudioUnitVarispeed()
    
    let volumeEffect = AVAudioUnitEQ()

    var engineAudioFile: AVAudioFile!
    var playLoops = false
   
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        setupAudioEngine()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier)! == "optionsSegue"{
            let optionsVC = segue.destination as! OptionsViewController
            optionsVC.delegateOptionsViewController = self
            
        }
    }
    
    
    // MARK: Playback (AVAudioEngine)
    func setupAudioEngine() {
        let format = audioAVEngine.inputNode.inputFormat(forBus: 0)
        audioAVEngine.attach(enginePlayer)
        
        audioAVEngine.attach(pitchEffect)
        audioAVEngine.attach(reverbEffect)
        audioAVEngine.attach(rateEffect)
        audioAVEngine.attach(volumeEffect)
        
        audioAVEngine.connect(enginePlayer, to: pitchEffect, format: format)
        audioAVEngine.connect(pitchEffect, to: reverbEffect, format: format)
        audioAVEngine.connect(reverbEffect, to: rateEffect, format: format)
        audioAVEngine.connect(rateEffect, to: volumeEffect, format: format)
        audioAVEngine.connect(volumeEffect, to: audioAVEngine.mainMixerNode, format: format)
        
        // Load reverb preset...
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.largeChamber)
        
        do {
            try audioAVEngine.start()
        } catch {
            print("Error starting AVAudioEngine.")
        }
    }
    
    // MARK: - Controls
    @IBAction func onRecord(_ sender: UIButton) {
        guard appHasMicAccess == true else {
            sender.isEnabled = false
            let theAlert = UIAlertController(title: "Requires Microphone Access",
                                             message: "Go to Settings > PenguinPet > Allow PenguinPet to Access Microphone.\nSet switch to enable.",
                                             preferredStyle: UIAlertController.Style.alert)
            let goSetting = { ( action: UIAlertAction) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            let cancel = { ( action: UIAlertAction) in
                theAlert.dismiss(animated: true, completion: {})
            }
            theAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: goSetting))
            theAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: cancel))
            present(theAlert, animated: true) {}
            return
        }
        if audioStatus != .playing {
            switch audioStatus {
            case .stopped:
                recordButton.setBackgroundImage(UIImage(named: "button-record1"), for: UIControl.State.normal )
                record()
            case .recording:
                recordButton.setBackgroundImage(UIImage(named: "button-record"), for: UIControl.State.normal )
                stopRecording()
            default:
                break
            }
        }
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        if audioStatus != .recording {
            switch audioStatus {
            case .stopped:
                play()
            case .playing:
                stopPlayback()
            default:
                break
            }
        }
    }
    
    func setPlayButtonOn(flag: Bool) {
        if flag == true {
            playButton.setBackgroundImage(UIImage(named: "button-play1"), for: UIControl.State.normal )
        }
        else {
            playButton.setBackgroundImage(UIImage(named: "button-play"), for: UIControl.State.normal )
        }
    }
    
    
}

// MARK: - AVFoundation Methods
extension ViewController: AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
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
    func  play(){
        let fileURL = getURLforMemo()
        var playFlag = true
        
        // Load Sound into AVAudioFile...
        do {
            engineAudioFile = try AVAudioFile(forReading: fileURL)
            // Setup Effects
            pitchEffect.pitch = UserSetting.shared.pitch
            reverbEffect.wetDryMix = UserSetting.shared.reverb
            rateEffect.rate = UserSetting.shared.rate
            volumeEffect.globalGain = UserSetting.shared.volume
        } catch {
            engineAudioFile = nil
            playFlag = false
            print("Error loading AVAudioFile.")
        }
        
        // Load AVAudioPlayer for metering...
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = self
            if audioPlayer.duration > 0.0 {
                audioPlayer.volume = 0.0
                audioPlayer.isMeteringEnabled = true
                audioPlayer.prepareToPlay()
            } else {
                playFlag = false
            }
        } catch {
            audioPlayer = nil
            engineAudioFile = nil
            playFlag = false
            print("Error loading audioPlayer.")
        }
        
        if playFlag == true {
            enginePlayer.scheduleFile(engineAudioFile, at: nil, completionHandler: nil)
            enginePlayer.play()
            audioPlayer.play()
            setPlayButtonOn(flag: true)
            startUpdateLoop()
            audioStatus = .playing
        }
    }
    
    
    func stopPlayback() {
        setPlayButtonOn(flag: false)
        audioStatus = .stopped
        audioPlayer.stop()
        enginePlayer.stop()
        stopUpdateLoop()
        
    }  //  停止 回放 功能
    
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
                timeLabel.text = formattedCurrentTime(UInt(audioPlayer.duration - audioPlayer.currentTime))
                soundTimer = CFAbsoluteTimeGetCurrent()
            }
            animateMouth(frame: meterLevelsToFrame())
        }
    }

    func stopUpdateLoop(){
        updateTimer.invalidate()
        updateTimer = nil
        // Update UI
        timeLabel.text = formattedCurrentTime(UInt(0))
        animateMouth(frame: 1)
    }

}


// MARK:- Panel

extension ViewController: OptionsViewControllerDelegate{
    func toSetVolumn(value: Float){
        volumeEffect.globalGain = value
    }

    func toSetRate(value: Float) {
        rateEffect.rate = value
    }
    
    func toSetPitch(value: Float) {
        pitchEffect.pitch = value
    }
    
    func toSetReverb(value: Float) {
        reverbEffect.wetDryMix = value
    }
}


// MARK:- Help Methods 动画相关

extension ViewController{
    func meterLevelsToFrame() -> Int{
        guard let player = audioPlayer else {
            return 1
        }
        player.updateMeters()
        let avgPower = player.averagePower(forChannel: 0)
        let linearLevel = meterTable.valueForPower(power: avgPower)
        // Convert to percentage
        let powerPercentage = Int(round(linearLevel * 100))
        // Divide percentage by number of frames
        let totalFrames = 5
        let frame = ( powerPercentage / totalFrames ) + 1
        return min(frame, totalFrames)
    }

    // 该用 哪一帧 图片
    func animateMouth(frame: Int){
        let frameName = "penguin_0\(frame)"
        let frameImage = UIImage(named: frameName)
        penguin.image = frameImage
    }
}
