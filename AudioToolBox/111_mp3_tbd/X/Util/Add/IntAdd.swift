//
//  IntAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/9.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit


extension CGFloat {
    
    var vue: CGFloat{
        CGFloat(Int(self))
    }
    
    
}



extension Int {
    
    var minusValid: Int{
        var minus = self / 60
        if minus == 0, self > 0{
            minus = 1
        }
        return minus
    }
    
   
    var ip: IndexPath{
        IndexPath(row: self, section: 0)
    }
}


extension TimeInterval {
    
    var minusValid: Int{
        Int(self).minusValid
    }
    
   
}




extension Int {


    func inRange(min lhs: Int, max rhs: Int) -> Int{
        let result = Swift.max(lhs, self)
        return Swift.min(result, rhs)
    }



    func withIn(max rhs: Int) -> Int{
        let right = Swift.max(0, rhs - 1)
        let result = Swift.max(0, self)
        return Swift.min(result, right)
    }
}
