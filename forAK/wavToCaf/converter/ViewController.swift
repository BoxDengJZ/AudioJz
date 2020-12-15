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

