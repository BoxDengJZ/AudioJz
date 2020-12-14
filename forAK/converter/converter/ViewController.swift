//
//  ViewController.swift
//  converter
//
//  Created by Jz D on 2020/12/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
    }

    
    
    
    @IBAction func mp3ToWav(_ sender: UIButton) {
        
        
        guard let source = Bundle.main.url(forResource: "1_Le Papillon", withExtension: "mp3") else{
            return
        }
        let output = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let outputUrl = URL(fileURLWithPath: output + "/one.wav")
        
        var options = FormatConverter.Options()
        // any options left nil will assume the value of the input file
        options.format = "wav"
        options.sampleRate = 44100
        options.bitDepth = 32

        let converter = FormatConverter(inputURL: source, outputURL: outputUrl, options: options)
        
        converter.start { (error) in
            if let err = error{
                print(err)
            }
        }
        
    }
    
    
    

}

