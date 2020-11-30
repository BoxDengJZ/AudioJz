//
//  PointAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/21.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit



extension CGPoint{
    
    func advance(_ offsetX: CGFloat = 0, y offsetY: CGFloat = 0) -> CGPoint{
        
        
        return CGPoint(x: x+offsetX, y: y+offsetY)
    }
    
    
    
    func replace(newY y: CGFloat = 0) -> CGPoint{
        
        
        return CGPoint(x: self.x, y: y)
    }
    
    func replace(newX x: CGFloat = 0) -> CGPoint{
        
        
        return CGPoint(x: x, y: self.y)
    }
}


extension CGRect{
    
    mutating func advance(_ orig: CGPoint, x offsetX: CGFloat = 0, y offsetY: CGFloat = 0){
        
        origin = orig.advance(offsetX, y: offsetY)
        
    }
    
    
    
    
}



func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}






func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}




