//
//  PlayerProgressBar.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit


import SnapKit


enum PlayerProgressOption{
    case play, pause, update(Float)
}

protocol PlayerProgressProxy: class {
    func doTheProgress(player stus: PlayerProgressOption)
}




class PlayerProgressBar: UIView {
    
    let h: CGFloat = 45
    
    lazy var lhsCurrentTimeL: UILabel = {
        let l = UILabel()
        l.textColor = UIColor(rgb: 0x575A61)
        l.textAlignment = .center
        l.font = UIFont.semibold(ofSize: 12)
        l.text = "00:00"
        return l
    }()
    
    
    lazy var rhsDurationTimeL: UILabel = {
        let l = UILabel()
        l.textColor = UIColor(rgb: 0x575A61)
        l.textAlignment = .center
        l.font = UIFont.semibold(ofSize: 12)
        l.text = "00:00"
        return l
    }()
    
    
    
    lazy var progressBar: UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.maximumValue = 1
        s.value = 0
        
        s.maximumTrackTintColor = UIColor(rgb: 0xF0F4F8)
        s.minimumTrackTintColor = UIColor(rgb: 0x0080FF)
        s.setThumbImage(UIImage(named: "progressCenter"), for: UIControl.State.normal)
        return s
    }()
    
    
    weak var delegate: PlayerProgressProxy?


    
    lazy var line: UIView = {
        let l = UIView()
        l.backgroundColor = UIColor(rgb: 0xEEEEEE)
        return l
    }()
    
    
    
    var val: Float{
        progressBar.value
    }
    
    
    
    init() {
       
        super.init(frame: CGRect.zero)
        
        doLayout()
        
        
        
        doEvents()
        
        
    }
    

    
    
    func doLayout(){
        backgroundColor = UIColor.white
        
        addSubs([lhsCurrentTimeL, rhsDurationTimeL,  progressBar, line])

        
        progressBar.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(50)
            m.trailing.equalToSuperview().offset(-50)
            m.height.equalTo(20)
            m.centerY.equalToSuperview()
        }
        lhsCurrentTimeL.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(15)
            m.top.equalToSuperview().offset(15)
            
        }
        
        
        rhsDurationTimeL.snp.makeConstraints { (m) in
            m.trailing.equalToSuperview().offset(-15)
            m.top.equalTo(lhsCurrentTimeL)
            
        }
        
        line.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalTo(1)
        }
    }
    
    
    
    
    
    func doEvents(){
        progressBar.rx.controlEvent([.touchDown]).subscribe(onNext: { [weak self]  () in
            // 感觉有一个订阅刷新
            guard let `self` = self else { return }
            self.delegate?.doTheProgress(player: .pause)
        }).disposed(by: rx.disposeBag)
        
        
        
        progressBar.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel]).subscribe(onNext: { [weak self]  () in
            guard let `self` = self else { return }
            self.delegate?.doTheProgress(player: .play)
            
        }).disposed(by: rx.disposeBag)
        
        progressBar.rx.value.subscribe(onNext: { [weak self]  (value) in
            guard let `self` = self else { return }
            self.delegate?.doTheProgress(player: .update(value))
            let v = Double(value)
            self.config(current: v)
        }).disposed(by: rx.disposeBag)
        
        
    }
    
    
    
    func config(current t: TimeInterval){
        lhsCurrentTimeL.text = t.mmSS
        
        let velvet = Float(t)
        progressBar.value = velvet
    }
    
    
    func config(total amount: TimeInterval){
        let t = max(1, amount)
        progressBar.maximumValue = Float(amount)
        
        rhsDurationTimeL.text = t.mmSS
        let son: TimeInterval = 0
      
        
        
        progressBar.value = Float(son)
        lhsCurrentTimeL.text = son.mmSS
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
