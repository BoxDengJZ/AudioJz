//
//  ButtonAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/4.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit


extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: forState)
    }
    
    
    func imgDefault(_ name: String){
        setImage(UIImage(named: name), for: UIControl.State.normal)
    }
    
    func imgSelected(_ name: String){
        setImage(UIImage(named: name), for: UIControl.State.selected)
    }

    
    func txtColorDefault(_ hex: Int){
        setTitleColor(UIColor(rgb: hex), for: UIControl.State.normal)
    }
    
    func titleDefault(_ name: String){
        setTitle(name, for: UIControl.State.normal)
    }
    
    
    convenience init(img: String) {
        self.init()
        setImage(UIImage(named: img), for: UIControl.State.normal)
    }
    
    
    convenience init(p: String) {
        self.init()
        setImage(UIImage(named: p), for: UIControl.State.normal)
        isHidden = true
    }
}
