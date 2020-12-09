//
//  BottomPopP_proxy.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import Foundation

import UIKit


extension BottomPopP: UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0x575A61)
        return v
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor(rgb: 0x575A61)
        return v
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectYeB(idx: indexPath.row, src: kind)
    }
}






extension BottomPopP: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch kind {
        case .interval:
            return secondsSpan.count
        case .times:
            return sourceTime.count
        }
        
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeue(for: PopChooseCel.self, ip: indexPath)
        switch kind {
        case .interval:
            let span = secondsSpan[indexPath.row].format(f: ".0") + " 秒"
            item.config(title: span)
        case .times:
            item.config(title: "\(sourceTime[indexPath.row]) 遍")
        }
        
        
        return item
    }
    
    
    
    
    
}






