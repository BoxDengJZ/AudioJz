//
//  BottomPopP.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit



struct BottomPopData {
    static let interval: [TimeInterval] = [20, 10, 5,
                           3, 1]
    
    
    
    static let times = ["3 遍", "2 遍", "1 遍"]
}



protocol BottomPopP_delegate: class {
    func selectYeB(idx index: Int, src kind: BottomPopKind) 
}


enum BottomPopKind{
    case interval
    case times
}


class BottomPopP: UIView {

    weak var delegate: BottomPopP_delegate?
    
    var sourceTime = BottomPopData.times
    
    let secondsSpan = BottomPopData.interval
    
    var kind = BottomPopKind.interval
    
    lazy var optionTb: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.register(for: PopChooseCel.self)
        tb.backgroundColor = UIColor(rgb: 0x575A61)
        return tb
    }()
    
    let lhsH: CGFloat = 198
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubs([optionTb])
        
        optionTb.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    
    
    

}
