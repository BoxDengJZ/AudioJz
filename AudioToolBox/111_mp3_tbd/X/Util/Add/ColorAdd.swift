//
//  Color.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/20.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit



extension UIColor {
    
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    
    
    convenience init(rgb: Int, alpha: CGFloat = 1) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
}



extension UIColor{
    
    // 主色调
    static let main = UIColor(rgb: 0x0080FF)
    

    
    static let txt = UIColor(rgb: 0x404248)
    
    static let cloak = UIColor(red: 240/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1)
}



struct UnifyLayout {
    static let std = UnifyLayout()
    
    
    let offset: CGFloat = 15
}
