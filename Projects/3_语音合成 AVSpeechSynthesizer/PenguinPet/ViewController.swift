//
//  ViewController.swift
//  PenguinPet
//
//  Created by Michael Briscoe on 1/13/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
// 

import UIKit
import AVFoundation

class ViewController: UIViewController {

  @IBOutlet weak var penguin: UIImageView!
  @IBOutlet weak var playButton: UIButton!
  
  var audioStatus: AudioStatus = AudioStatus.stopped
  var updateTimer: CADisplayLink!
  
  var speechTimer: CFTimeInterval = 0.0
  
  let synthesizer = AVSpeechSynthesizer()

  // MARK: - Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    synthesizer.delegate = self
  }

   override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "optionsSeque" {
            let optionsVC = segue.destination as! OptionsViewController
            optionsVC.delegate = self
        }
    }
    
    
    // MARK: - Controls
    @IBAction func onPlay(_ sender: UIButton) {
        
        switch audioStatus {
        case .stopped:
            play()
        case .playing:
            pausePlayback()
        case .paused:
            continuePlayback()
        }
        
    }
    

  func setPlayButtonOn(_ flag: Bool) {
    if flag == true {
        playButton.setBackgroundImage(UIImage(named: "button-play1"), for: UIControl.State.normal)
    } else {
        playButton.setBackgroundImage(UIImage(named: "button-play"), for: UIControl.State.normal)
    }
  }
  
  // MARK: - Update Loop
  func startUpdateLoop() {
    if updateTimer != nil {
      updateTimer.invalidate()
    }
    updateTimer = CADisplayLink(target: self, selector: #selector(ViewController.updateLoop))
    updateTimer.preferredFramesPerSecond = 1
    updateTimer.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
  }
  
  func stopUpdateLoop() {
    if updateTimer != nil {
      updateTimer.invalidate()
      updateTimer = nil
    }
    // Update UI
    animateMouth(1)
  }
  
    
    @objc
  func updateLoop() {
    if audioStatus == .playing {
      if CFAbsoluteTimeGetCurrent() - speechTimer > 0.1 {
        animateMouth(1 + randomInt(5))
        speechTimer = CFAbsoluteTimeGetCurrent()
      }
    }
  }
  
  func animateMouth(_ frame: Int) {
    let frameName = "penguin_0\(frame)"
    let frame = UIImage(named: frameName)
    penguin.image = frame
  }

    
    
    
    func pausePlayback() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    
    func continuePlayback() {
        synthesizer.continueSpeaking()
    }
    
    
    
}

// MARK: - AVFoundation Methods
extension ViewController: AVSpeechSynthesizerDelegate {
  
  // MARK: Playback
  func  play() {
    let words = UserSetting.shared.message
    let utterance = AVSpeechUtterance(string: words)
    utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
    utterance.rate = AVSpeechUtteranceMaximumSpeechRate * UserSetting.shared.rate
    utterance.pitchMultiplier = UserSetting.shared.pitch
    synthesizer.speak(utterance)
  }
  
  func stopPlayback() {
    synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    stopUpdateLoop()
    setPlayButtonOn(false)
    audioStatus = .stopped
  }
  
  // MARK: Delegates
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    setPlayButtonOn(true)
    startUpdateLoop()
    audioStatus = .playing
  }
  
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    stopUpdateLoop()
    setPlayButtonOn(false)
    audioStatus = .stopped
  }
  
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    
    let speakingString = utterance.speechString as NSString
    let word = speakingString.substring(with: characterRange)
    print(word)
  }
  
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        stopUpdateLoop()
        setPlayButtonOn(false)
        audioStatus = .paused
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        setPlayButtonOn(true)
        startUpdateLoop()
        audioStatus = .playing
    }
    
  // MARK: - Helpers
  func randomInt(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
  }
    
    
}





extension ViewController: OptionsViewControllerDelegate{
    func doPlay() {
        if synthesizer.isSpeaking == true {
            stopPlayback()
        } else {
            play()
        }
    }
}
