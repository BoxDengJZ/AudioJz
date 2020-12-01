//
//  RectAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/26.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit


extension CGRect{
    
    var end: CGPoint{
        return CGPoint(x: maxX, y: maxY)
    }
    
    var leftBottom: CGPoint{
        return CGPoint(x: minX, y: maxY)
    }
    
    var rightUp: CGPoint{
        return CGPoint(x: maxX, y: minY)
    }
}



struct UI {
    
    static let std = UI()
    
    var height: CGFloat{
        UIScreen.main.bounds.height
    }
    
    
    var layout: CGRect{
        UIScreen.main.bounds
    }
    
    
    var width: CGFloat{
        UIScreen.main.bounds.width
    }
    
    var bigS: Bool{
        UIScreen.main.bounds.height >= 812 || special
    }
    

    
    var center: CGPoint{
        CGPoint(x: width * 0.5, y: height * 0.5)
    }
    
    
    var origineY: CGFloat{
        return 20
    }
    
    
    
    var bottomOffsetY: CGFloat{
        if bigS{
            return 34
        }
        else{
            return 0
        }
    }
    
    
    var contentY: CGFloat{
        origineY + 64
    }
    
    
    var special: Bool{
        UIScreen.main.bounds.width <= 320
    }
}









public func * (left: CGFloat, right: Int) -> CGFloat {
    return left * CGFloat(right)
}


public func * (left: Int, right: CGFloat) -> CGFloat {
    return CGFloat(left) * right
}



extension CGFloat{
    var scalar: CGFloat{
        CGFloat(Int(self))
    }
}



extension CGRect{
    func right(x offset: CGFloat) -> CGRect{
        CGRect(origin: CGPoint(x: origin.x + offset, y: origin.y), size: size)
    }
        
    
}
