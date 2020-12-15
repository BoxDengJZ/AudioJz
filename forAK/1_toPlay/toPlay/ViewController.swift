//
//  ViewController.swift
//  toPlay
//
//  Created by Jz D on 2020/12/15.
//

import UIKit

import AVFoundation


class ViewController: UIViewController {
    
    
    let engine = AudioEngine()
    let player = AudioPlayer()
    
    
    @IBOutlet weak var playBtn: UIButton!
    
    
    
    @IBOutlet weak var lengthLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.isLooping = true
        engine.output = player
        do {
            try engine.start()
        } catch {
            print("AudioKit did not start! \(error)")
        }
        
        
        
 
    }

    
    
    
    
    
    
    @IBAction func toPlay(_ sender: Any) {
        if player.isPlaying{
            toPause()
        }
        else{
            toPlay()
        }
    }
    
    
    func toPause(){
        player.stop()
        playBtn.setTitle("去播放", for: .normal)
    }
    
    
    
    func toPlay(){
        player.stop()
        let url = Bundle.main.url(forResource: "1_Le Papillon", withExtension: "mp3")
        
        var file: AVAudioFile?
        
        do {
            file = try AVAudioFile(forReading: url!)
        } catch {
            print(error)
        }
        
        
        guard let f = file else {
            return
        }
        lengthLabel.text = "音频时长是 \(f.duration.mmSS)"
        
        let buffer = try! AVAudioPCMBuffer(file: f)!
        player.buffer = buffer
        player.schedule(at: nil)
        player.play()
        playBtn.setTitle("在播放，去关掉", for: .normal)
    }
    
    
    
    

}






extension TimeInterval {
    
    /// Converts a `TimeInterval` into a MM:SS formatted string.
    ///
    /// - Returns: A `String` representing the MM:SS formatted representation of the time interval.
    var mmSS: String {
        let ts = Int(self)
        let s = ts % 60
        let m = (ts / 60) % 60
        return String(format: "%02d:%02d", m, s)
    }
    
}

