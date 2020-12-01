//
//  P_ intelligence.swift
//  petit
//
//  Created by Jz D on 2020/10/30.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation



struct P_intelligence: Decodable {
    
    let listen: String
    
    let see: Node_intelligence
    
    
    let list: [Moron]
    
    let title: String
    
    
    let pre: Int
    
    let next: Int
    let author: String?
    
    
    private enum CodingKeys : String, CodingKey {
        case listen = "audio", see = "nodes"
        case list,  title, pre = "prev_id"
        case next = "next_id", author
    }
    
    
    
    var oreoPercent: [Double]?{
        let moments = see.wav_lengths
        
        guard let len = moments.last else {
            return nil
        }
        return see.node.map { (oreo) -> Double in
            moments[oreo.index] / len
        }
            
    }

}





struct Moron: Decodable {
    let string: String
    let type: Int
    let pronounce: String?
}




extension Moron{
    var str: String{
        string.replacingOccurrences(of: "_", with: " ")
    }
}





struct Node_intelligence: Decodable {

    let wav_lengths: [TimeInterval]
    let node: [Federal_tag]
    
}



struct Federal_tag: Decodable{
    let index: Int
    let title: String
}




