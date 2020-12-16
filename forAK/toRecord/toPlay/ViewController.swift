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

    var recorder: NodeRecorder?
    
    let mixer = Mixer()
    
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var lengthLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let input = engine.input else {
            fatalError()
        }

        do {
            recorder = try NodeRecorder(node: input)
        } catch let err {
            fatalError("\(err)")
        }
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            print("AudioKit did not start! \(error)")
        }
    }

    
    @IBAction func tapToRecord(_ sender: Any) {
        if recorder != nil, recorder!.isRecording{
            toStop()
        }
        else{
            toRecord()
        }
    }
    
    
    func toStop(){
        recorder?.stop()
        recordBtn.setTitle("去录音", for: .normal)
        
        let file = recorder?.audioFile

        guard let f = file else {
            return
        }
        lengthLabel.text = "录音时长是 \(f.duration.mmSS)"
    }
    
    
    
    func toRecord(){
        NodeRecorder.removeTempFiles()
        do {
            try recorder?.record()
        } catch let err {
            print(err)
        }
        recordBtn.setTitle("在录音，去关掉", for: .normal)
        lengthLabel.text = "录音时长: -"
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

