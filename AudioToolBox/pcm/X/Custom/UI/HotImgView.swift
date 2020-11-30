//
//  HotImgView.swift
//  musicSheet
//
//  Created by Jz D on 2019/10/17.
//  Copyright © 2019 Jz D. All rights reserved.
//

import Foundation
import UIKit


class HotImg: UIImageView{
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let width = bounds.size.width
        let height = bounds.size.height
        let offset: CGFloat = 15
        let frame = CGRect(x: offset * (-1), y: offset * (-1), width: width + offset * 2, height: height + offset * 2)
        return frame.contains(point)
    }
    

}



class HotP_Img: UIImageView{
    
    
    
    override init(image: UIImage?) {
        super.init(image: image)
        isUserInteractionEnabled = true
        
    }
    override init(frame: CGRect) {
        fatalError()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let width = bounds.size.width
        let height = bounds.size.height
        let offset: CGFloat = 8
        let frame = CGRect(x: offset * (-1), y: offset * (-1), width: width + offset * 2, height: height + offset * 2)
        return frame.contains(point)
    }
    

}



class HotBtn: UIButton{
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let width = bounds.size.width
        let height = bounds.size.height
        let offset: CGFloat = 15
        let frame = CGRect(x: offset * (-1), y: offset * (-1), width: width + offset * 2, height: height + offset * 2)
        return frame.contains(point)
    }
    

}
