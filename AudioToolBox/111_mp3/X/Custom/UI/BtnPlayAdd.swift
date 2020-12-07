//
//  BtnPlayAdd.swift
//  petit
//
//  Created by Jz D on 2020/10/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit




extension UIButton{
    
    
    func sideSelected(){
        backgroundColor = UIColor.blue
        setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func sideNormal(){
        backgroundColor = UIColor.white
        setTitleColor(UIColor.black, for: .normal)
    }
    
    
    
    
    func sideToggle(){
        if isSelected{
            sideSelected()
        }
        else{
            sideNormal()
        }
    }
}
