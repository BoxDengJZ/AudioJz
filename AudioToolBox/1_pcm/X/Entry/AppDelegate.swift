//
//  AppDelegate.swift
//  iOS Example
//
//  Created by Dan Shevlyuk on 11/16/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

import StoreKit
import AVFoundation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        gotoMain()
        audio()
        
        
        return true
    }

    
    func gotoMain(){
        if window == nil{
            window = UIWindow(frame: UI.std.layout)
        }
        window?.makeKeyAndVisible()
        
        window?.rootViewController = PlayerController()
        
    }
    
    
    
    func audio(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //  try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.mixWithOthers)
            
            
            try audioSession.setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            audioSession.requestRecordPermission({ (isGranted: Bool) in
                
            })
        } catch  {
            
        }
    }
    
    
}

