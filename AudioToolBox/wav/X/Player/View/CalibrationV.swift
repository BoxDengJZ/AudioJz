//
//  CalibrationV.swift
//  petit
//
//  Created by Jz D on 2020/10/20.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class CalibrationV: UIView {

    
    var tubes = [Double](){
        didSet{
            
            setNeedsDisplay()
            
            
        }
        
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard tubes.isEmpty == false else {
            return
        }
        let path = UIBezierPath()
        for pt in tubes{
            let percent = CGFloat(pt)
            path.move(to: CGPoint(x: percent * rect.width, y: 0))
            path.addLine(to: CGPoint(x: percent * rect.width, y: rect.height))
        }
        
        UIColor.red.setStroke()
        path.stroke()
        
        
    }
    

}





class InnerL: UILabel{
    
    
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    
}
