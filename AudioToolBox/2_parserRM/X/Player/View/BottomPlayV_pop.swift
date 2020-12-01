//
//  BottomPlayV_pop.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation



import UIKit



extension BottomPlayV{
    
    func comePopLhs(){
        UIView.animate(withDuration: 0.3) {
            self.topLhsIntervalConstraint?.constraint.update(offset: self.lhsPopInterval.lhsH.neg)
            self.layoutIfNeeded()
        }
    }
    
    
    func goPopLhs(){
        UIView.animate(withDuration: 0.3) {
            self.topLhsIntervalConstraint?.constraint.update(offset: 0)
            self.layoutIfNeeded()
        }
    }
    
    
    
    func fuckEnIngLhs(){
        if lhsPopInterval.frame.origin.y < 0{
            goPopLhs()
        }
        else{
            comePopLhs()
        }
    }
    
    
    func comePopRhs(){
        UIView.animate(withDuration: 0.3) {
            self.topRhsTimesConstraint?.constraint.update(offset: -121)
            self.layoutIfNeeded()
        }
    }
    
    func goPopRhs(){
        UIView.animate(withDuration: 0.3) {
            self.topRhsTimesConstraint?.constraint.update(offset: 0)
            self.layoutIfNeeded()
        }
    }
    
    func riYingTimesRhs(){
        if rhsPopRepeat.frame.origin.y < 0{
            goPopRhs()
        }
        else{
            comePopRhs()
        }
    }
}




extension BottomPlayV: BottomPopP_delegate{
    
    
    func selectYeB(idx index: Int, src kind: BottomPopKind){
        ggg()
        
        switch kind {
        case .interval:
            let val = BottomPopData.interval[index]
            intervalB.text = val.interval
            delegate?.change(interval: val)
        case .times:
            let val = 3 - index
            repeatB.setTitle("重复：x\(val)", for: .normal)
            delegate?.change(times: val)
        }
    }



}


extension TimeInterval{
    var interval: String{
        "间隔:\(format(f: ".0")) 秒"
    }
}
