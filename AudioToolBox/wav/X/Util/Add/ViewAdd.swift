//
//  ViewAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/22.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit


protocol DarkMask {
    func isMask()
}

protocol CornerClip {
    func corner(_ clip: CGFloat)
}



extension UIView: DarkMask{
    
    func isMask(){
        backgroundColor = UIColor.black
        alpha = 0.6
        
    }
  
}



extension UIView: CornerClip{
    
    func corner(_ clip: CGFloat) {
        layer.cornerRadius = clip
        clipsToBounds = true
        
    }
    
    
    func border(color col: UIColor, bordW wid: CGFloat = 1) {
        layer.borderWidth = wid
        layer.borderColor = col.cgColor
        
    }

}


extension UIView{
    
    static func white() -> UIView{
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }
    
    
    static func clear() -> UIView{
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    var width: CGFloat{
        return bounds.size.width
    }
    
    
    var height: CGFloat{
        return bounds.size.height
    }
    
    
    var searchBarWidth: CGFloat{
        var width: CGFloat = 490
        width = UI.std.width * width / 1024
        return width
    }
}


extension UIView{
     // mask 添加之后，又该怎么解除
    func mask(_ rect: CGRect, other: CGRect = CGRect.zero, isOval: Bool = false) {
        mask = nil
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        path.addRect(bounds)
        if isOval{
            path.addPath(CGPath(ellipseIn: rect, transform: nil))
        }
        else{
            path.addRect(rect)
        }
        
        if other != .zero{
            path.addRect(other)
        }
        
        maskLayer.path = path
        
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        
        // Set the mask of the view.
        layer.mask = maskLayer;
    }
   
    
    func addSubs(_ views: [UIView]){
        views.forEach(addSubview(_:))
    }
    
}

    
    
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}




extension UIView{
    var kiss :String {
        "\(type(of: self))"
    }
    
    
    
    
    func chase(percent p: Double) -> CGFloat{
        print("frame.origin.x", frame.origin.x)
        
        print("frame.size.width", frame.size.width)
        return frame.origin.x + frame.size.width * CGFloat(p)
    }
    
}


extension UIViewController{
    var kiss :String {
        "\(type(of: self))"
    }
    
}
