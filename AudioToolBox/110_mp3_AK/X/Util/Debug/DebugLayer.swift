//
//  File.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/22.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import NSObject_Rx


extension CALayer{
    
    func debug(){
        borderColor = UIColor.blue.cgColor
        borderWidth = 1
    }
}








protocol UI_debug {
    func debug( _ event: @escaping (UITapGestureRecognizer) -> Void)
}



extension UIView: UI_debug{
// debugV
    func debug( _ event: @escaping (UITapGestureRecognizer) -> Void){
     //   isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 2
     //   addGestureRecognizer(tap)
     //   tap.rx.event.bind(onNext: event).disposed(by: rx.disposeBag)
    }
    
}


