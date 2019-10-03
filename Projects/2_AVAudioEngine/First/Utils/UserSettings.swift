//
//  UserSettings.swift
//  First
//
//  Created by Jz D on 2019/10/3.
//  Copyright © 2019 dengjiangzhou. All rights reserved.
//

import Foundation


enum Key{
    static let volume = "Volume"
    static let rate = "Rate"
    static let pitch = "Pitch"
    static let reverb = "Reverb"
}


struct UserSetting{
    
    static var shared = UserSetting()
    
    var volume: Float{
        get {
            return UserDefaults.standard.float(forKey: Key.volume)
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: Key.volume)
        }
    }
   

    
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
    
    var reverb: Float{
        get {
            return UserDefaults.standard.float(forKey: Key.reverb)
        }
        set(newVal){
            UserDefaults.standard.set(newVal, forKey: Key.reverb)
        }
    }

    
    func registerDefaults(){
        let factorySettings: [String: Any] = [Key.volume: 48,
                                              Key.rate: 1.0,
                                              Key.pitch: 2400,
                                              Key.reverb: 100 ]
        UserDefaults.standard.register(defaults: factorySettings)
    }
    
    
}
