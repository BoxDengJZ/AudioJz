//
//  Corp.swift
//  musicSheet
//
//  Created by Jz D on 2019/11/4.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit



struct CorpInfo {
    static let mail = "service@haoduoqupu.com"
    static let qq = "817272436"
}



extension Bool{
    var scalar: Int{
        var idx = 0
        if self{
            idx = 1
        }
        return idx
    }
    
    
    var alphaVal: CGFloat{
        var a: CGFloat = 0.2
        if self{
            a = 1
        }
        return a
    }
    
}



extension Optional where Wrapped : UIImage{
    var temp: UIImage?{
        self?.withRenderingMode(.alwaysTemplate)
    }
}
