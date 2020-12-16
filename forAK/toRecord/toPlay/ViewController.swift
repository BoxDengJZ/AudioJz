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

    
    
    @IBOutlet weak var recordBtn: UIButton!
    
    
    
    @IBOutlet weak var lengthLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
//        do {
//            try engine.start()
//        } catch {
//            print("AudioKit did not start! \(error)")
//        }
//
//
//
 
    }

    
    
    
    
    
    
    @IBAction func tapToRecord(_ sender: Any) {
        
    }
    
    
    func toStop(){
        
    }
    
    
    
    func toRecord(){
        
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

