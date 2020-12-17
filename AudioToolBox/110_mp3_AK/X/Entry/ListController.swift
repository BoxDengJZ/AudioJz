//
//  ListController.swift
//  SwiftSocket
//
//  Created by Jz D on 2020/12/8.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit


struct Piece {
    let music: String
}


class ListController: UIViewController {

    
    lazy var records: [Piece] = [Piece(music: "1_ひこうき雲"),
                                 Piece(music: "1_Le Papillon")]
    
    
    lazy var follow: UIView = { () -> UITableView in
        let tb = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tb.backgroundColor = UIColor(rgb: 0xF3F3F3)
        tb.register(for: VIP_CenterCell.self)
        tb.separatorStyle = .none
        
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubs([ follow ])
        follow.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    

}






extension ListController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return records.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeue(for: VIP_CenterCell.self, ip: indexPath)
        
        
        let bulk = records[indexPath.row]
        cell.configTail(bulk.music)
        
        return cell
    }
}






extension ListController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bulk = records[indexPath.row]
        let p = PlayerController(from: bulk.music)
        navigationController?.pushViewController(p, animated: true)
    }

}


