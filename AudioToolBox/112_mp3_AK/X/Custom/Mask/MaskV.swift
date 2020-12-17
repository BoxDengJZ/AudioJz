//
//  MyLibMask.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/27.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit




protocol SideMask: class {
    func hide(mask k: String)
}



class MaskV: UIView{
    
    
    
    weak var delegate: SideMask?
    
    var love: String = ""
    
    init(delegate proxy: SideMask){
        super.init(frame: CGRect.zero)
        isHidden = true
        isUserInteractionEnabled = true
        
        delegate = proxy
        
        isMask()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func remove(){
        if superview != nil{
            removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.hide(mask: love)
    }
    
}
 



extension MaskV{
    
    func hide(){
        alpha = 0
    }
    
    func show(){
        alpha = 0.15
    }
    
    
}


