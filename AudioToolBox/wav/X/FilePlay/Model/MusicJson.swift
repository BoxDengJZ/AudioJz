//
//  MusicJson.swift
//  petit
//
//  Created by Jz D on 2020/10/20.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation



struct ReadableDat: Decodable {
    
    let text_node: Int
    let time_node: [TimeInterval]
    let word_node: Int
   
    var oreoPercent: [Double]?{
        if let len = time_node.last{
            return [time_node[text_node] / len, time_node[word_node] / len]
        }
        else{
            return nil
        }
    }
    
    
    var cookieAbs: [Double]{
        [time_node[text_node], time_node[word_node] ]
    }
     
}
