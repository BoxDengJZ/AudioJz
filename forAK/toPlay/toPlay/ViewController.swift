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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        engine.output = player
        do {
            try engine.start()
        } catch {
            print("AudioKit did not start! \(error)")
        }
        
        
        
 
    }

    
    
    
    
    
    
    @IBAction func toPlay(_ sender: Any) {
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
        
        
        let buffer = try! AVAudioPCMBuffer(file: f)!
        player.buffer = buffer
        
        player.play()
    }
    
    
    
    
    
    
    
    
    

}

