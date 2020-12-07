//
//  CalibrationV.swift
//  petit
//
//  Created by Jz D on 2020/10/20.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class CalibrationV: UIView {

    
    // 声音的粒度，一次一个字，
    
    // 声音数据不是按照 UInt 16 来拆分，
    
    // 是按照一个字，来拆
    
    
    
    
    
    var tubes = [Double](){
        didSet{
            
            setNeedsDisplay()
            
            
        }
        
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        UIColor(rgb: 0xF9F9F9).setFill()
        UIRectFill(rect)
        
        guard tubes.isEmpty == false else {
            return
        }
        
        let path = UIBezierPath()
        path.lineWidth = 2
        for pt in tubes{
            let percent = CGFloat(pt)
            path.move(to: CGPoint(x: percent * rect.width, y: 0))
            path.addLine(to: CGPoint(x: percent * rect.width, y: rect.height))
        }
        
        UIColor.red.setStroke()
        path.stroke()
        
        
    }
    

}



// 进度条，应该只前进，不后退，

// 二维进度条，大进度里面套着小进度


// 多个圆环，一个环是一个章节

// 每个章节自己的进度，就是其圆环的百分比

class InnerL: UILabel{
    
    
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    
}
