//
//  UserSettings.swift
//  First
//
//  Created by Jz D on 2019/10/3.
//  Copyright © 2019 dengjiangzhou. All rights reserved.
//

import Foundation
import AVFoundation

enum Key{
    static let message = "Message"
    static let rate = "Rate"
    static let pitch = "Pitch"
}


struct UserSetting{
    
    private let dong = "花褪残红青杏小，燕子飞时，绿水人家绕。枝上柳绵吹又少，天涯何处无芳草。墙里秋千墙外道，墙外行人，墙里佳人笑。笑渐不闻声渐悄，多情却被无情恼。"
    
    static var shared = UserSetting()

    var rate: Float{
        get {
            return UserDefaults.standard.float(forKey: Key.rate)
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: Key.rate)
        }
    }
    
    var pitch: Float{
        get {
            return UserDefaults.standard.float(forKey: Key.pitch)
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: Key.pitch)
        }
    }
    
    var message: String{
        get {
            guard let dongPo = UserDefaults.standard.string(forKey: Key.message) else{
                return dong
            }
            return dongPo
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: Key.message)
        }
    }

    
    func defaults(){
        
        var factorySettings = [String: Any]()
        factorySettings[Key.message] = dong
        factorySettings[Key.pitch] = 1.0
        factorySettings[Key.rate] = AVSpeechUtteranceDefaultSpeechRate
        
        UserDefaults.standard.register(defaults: factorySettings)
    }
    
    
    func reset(){
        UserSetting.shared.message = dong
        UserSetting.shared.pitch = 1.0
        UserSetting.shared.rate = AVSpeechUtteranceDefaultSpeechRate
    }
}
