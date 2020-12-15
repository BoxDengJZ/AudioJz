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

    
    
    
    @IBAction func wavToCaf(_ sender: UIButton) {
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        
        guard let source = Bundle.main.url(forResource: "666", withExtension: "wav") else{
            return
        }

        let outputUrl = URL(fileURLWithPath: dir + "/one.caf")
        
        var options = FormatConverter.Options()
        // any options left nil will assume the value of the input file
        options.format = "caf"
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



/*
 
 
 [caf @ 0x7f824300fc00] Estimating duration from bitrate, this may be inaccurate
 Input #0, caf, from 'one.caf':
   Duration: 00:01:03.16, start: 0.000000, bitrate: 1411 kb/s
     Stream #0:0: Audio: pcm_s32le (lpcm / 0x6D63706C), 44100 Hz, 1 channels, s32, 1411 kb/s

 }
 
 
 */
