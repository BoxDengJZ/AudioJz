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
    
    
    

    
    
    
    
    
    
    @IBAction func wavToM4a(_ sender: Any) {
        
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let source = URL(fileURLWithPath: dir + "/one.wav")
        
        guard FileManager.default.fileExists(atPath: source.path) else {
            print("wav 文件不存在，请点击上一步按钮  /n 点击上一步按钮,还不行，请添加自己的 mp3 文件")
            return
        }
        var options = FormatConverter.Options()
        // any options left nil will assume the value of the input file
        options.format = "m4a"

        let outputUrl = URL(fileURLWithPath: dir + "/one.m4a")
        let converter = FormatConverter(inputURL: source, outputURL: outputUrl, options: options)
        
        converter.start { (error) in
            if let err = error{
                print(err)
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    @IBAction func mp3ToM4a(_ sender: Any) {
        
        
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        guard let source = Bundle.main.url(forResource: "1_Le Papillon", withExtension: "mp3") else{
            return
        }
        
        var options = FormatConverter.Options()
        // any options left nil will assume the value of the input file
        options.format = "m4a"

        let outputUrl = URL(fileURLWithPath: dir + "/two.m4a")
        let converter = FormatConverter(inputURL: source, outputURL: outputUrl, options: options)
        print("dir: \n\(dir)")
        converter.start { (error) in
            if let err = error{
                print(err)
            }
        }
        
        
        
        
        
        
        
    }
}

