//
//  P_ intelligence.swift
//  petit
//
//  Created by Jz D on 2020/10/30.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation



struct P_intelligence {
    

    let list: [NodeK]
    
    
    func oreoPercent(duration len: TimeInterval) -> [Double]{

        return list.map { (oreo) -> Double in
            oreo.time / len
        }
            
    }

}





struct NodeK: Decodable {

    let time: TimeInterval
    let content: String
    
}




extension NodeK{
    var sentence: String{
        content.replacingOccurrences(of: "- - - -", with: "\n\n")
    }
}
