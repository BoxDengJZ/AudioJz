//
//  SideHeader.swift
//  musicSheet
//
//  Created by Jz D on 2019/12/19.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit


protocol SideHeaderProxy: class {
    
    func xForce()
    
}



protocol SideHeaderDelegate: class {
    
    var h: SideHeader{ get set }
    var view: UIView! {get}

    
    
    func xForce()
    
}

extension SideHeaderDelegate{
    
    func layout_h(_ offset: CGFloat = 0){
        view.addSubs([h])
        h.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(UI.std.contentY)
            maker.top.equalToSuperview()
        }
    }
    
}





protocol SideHeadWithRhsDelegate: SideHeaderDelegate {
    
    var rhs: HotImg{ get set }
    
}


extension SideHeadWithRhsDelegate {
    
    func createRhs(_ name: String) -> HotImg{
        let img = HotImg(image: UIImage(named: name))
        img.isUserInteractionEnabled = true
        return img
    }
    
    func layoutRhs(){
        h.addSubview(rhs)
        rhs.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 18, height: 18))
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-16)
        }
    }
    
    
}



class SideHeader: UIView {
    
    
    weak var delegate: SideHeaderDelegate?
    
    
    weak var proxy: SideHeaderProxy?
    
    let hyperextension: String
    let preacher: String
    
    lazy var headline = { () -> UILabel in
        let lbl = UILabel()
        lbl.font = UIFont.myStudyTitle
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        
        lbl.text = hyperextension
        return lbl
    }()
    
    lazy var arrow = { () -> UIImageView in
        let img = UIImageView()
        img.image = UIImage(named: preacher)
        img.isUserInteractionEnabled = true
        return img
    }()
    
    let line: UIView = {
        let string = UIView()
        string.backgroundColor = UIColor(rgb: 0xECECEC)
        return string
    }()
    
    init(title name: String, icon: String = "player_back_arrow") {
        hyperextension = name
        preacher = icon
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        addSubs([headline, arrow, line])
        
        headline.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(20 + UI.std.origineY)
            maker.size.equalTo(CGSize(width: 350, height: 25))
        }
       
        arrow.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.top.equalToSuperview().offset(17 + UI.std.origineY)
            maker.leading.equalToSuperview().offset(16)
        }
       
        line.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.bottom.equalToSuperview()
        }
        
        actions()
    }
    
    
    
    override init(frame: CGRect) {
         fatalError("没实现  2  ")
    }
    
    
    func actions(){
        let tap = UITapGestureRecognizer()
        arrow.addGestureRecognizer(tap)
        tap.rx.event.bind { (event) in
            self.delegate?.xForce()
            self.proxy?.xForce()
        }.disposed(by: rx.disposeBag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("没实现")
    }
 
    
    func change(title name: String){
        headline.text = name
    }
}
