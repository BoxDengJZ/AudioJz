//
//  ArrayAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/5.
//  Copyright © 2019 Jz D. All rights reserved.
//

import Foundation



extension Array{
    var aHead: [Iterator.Element]{
        get{
            guard isEmpty == false else {
                return []
            }
            let reciprocal = index(before: endIndex)
            return Array(self[..<reciprocal])
        }
    }
}



extension Array where Iterator.Element == Int{


    mutating
    func stride(span n: Int){
        guard n > 0 else {
            return
        }
        let c = count
        for i in 1...n{
            append(c + i)
        }
    }




}
