//
//  BottomPlayV.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit


import SnapKit



enum Orientation{
    case lhs
    case rhs
}



protocol BottomPlayBoardProxy: class {
    func change(interval t: TimeInterval)
    
    func change(times num: Int)
    
    func enterPlay()
    
    func secondPlay()
    
    func to(page direction: Orientation)
}


class BottomPlayV: UIView {


    
    weak var delegate: BottomPlayBoardProxy?
    
    
    let niMaH: CGFloat = 10
    
    private
    lazy var playB: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "my_p_play"), for: .normal)
        return b
    }()
    
    
    lazy var lhsGoB: UIButton = {
        let b = UIButton()
        b.setTitle("上一篇", for: .normal)
        b.setTitleColor(UIColor(rgb: 0x575A61), for: .normal)
        b.titleLabel?.font = UIFont.semibold(ofSize: 12)
        b.backgroundColor = UIColor(rgb: 0xF0F4F8)
        b.corner(2)
        return b
    }()
    
    
    
    lazy var rhsGoB: UIButton = {
        let b = UIButton()
        b.setTitle("下一篇", for: .normal)
        b.setTitleColor(UIColor(rgb: 0x575A61), for: .normal)
        b.titleLabel?.font = UIFont.semibold(ofSize: 12)
        b.backgroundColor = UIColor(rgb: 0xF0F4F8)
        b.corner(2)
        return b
    }()
    

    
    lazy var secondPlayB: UIButton = {
        let b = UIButton()
        b.isHidden = true
        b.setTitle("暂停一下", for: .normal)
        b.setTitle("继续播放", for: .selected)
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.semibold(ofSize: 12)
        b.backgroundColor = UIColor(rgb: 0x0080FF)
        b.corner(2)
        return b
    }()
    
    
    lazy var repeatB: UIButton = {
        let b = UIButton()
        b.isHidden = true
        b.setTitle("重复：x1", for: .normal)
        b.setTitleColor(UIColor(rgb: 0x575A61), for: .normal)
        b.titleLabel?.font = UIFont.semibold(ofSize: 12)
        b.titleLabel?.textAlignment = .center
        b.backgroundColor = UIColor(rgb: 0xF0F4F8)
        b.corner(2)
        return b
    }()
    
    
    
    lazy var intervalB: InnerL = {
        let b = InnerL()
        b.isHidden = true
        b.text = BottomPopData.interval[BottomPopData.interval.count - 1].interval
        b.font = UIFont.semibold(ofSize: 12)
        b.textColor = UIColor(rgb: 0x575A61)
        b.textAlignment = .left
        b.isUserInteractionEnabled = true
        b.backgroundColor = UIColor(rgb: 0xF0F4F8)
        b.corner(2)
        return b
    }()
    
    
    lazy var lhsPopInterval: BottomPopP = {
        let p = BottomPopP()
        p.kind = .interval
        p.delegate = self
        return p
    }()
    
    
    lazy var rhsPopRepeat: BottomPopP = {
        let p = BottomPopP()
        p.kind = .times
        p.delegate = self
        return p
    }()
    
    
    var topLhsIntervalConstraint: ConstraintMakerEditable?
    
    
    var topRhsTimesConstraint: ConstraintMakerEditable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        forLayout()
        doEvents()
    }
    
    
    func forLayout(){
        backgroundColor = UIColor.white
        let bg = UIView()
        bg.backgroundColor = UIColor.white
        
        let upBg = UIView()
        upBg.backgroundColor = UIColor.white
        addSubs([lhsPopInterval, rhsPopRepeat,  bg, upBg])
        upBg.addSubs([playB, lhsGoB, rhsGoB ,
                      repeatB, intervalB, secondPlayB ])
        upBg.snp.makeConstraints { (m) in
            m.leading.trailing.top.equalToSuperview()
            m.bottom.equalToSuperview().offset(niMaH.neg)
        }
        
        bg.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        playB.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 50, height: 50))
            m.centerX.equalToSuperview()
            m.centerY.equalToSuperview().offset(-2)
        }
        
        
        lhsGoB.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 70, height: 35))
            m.leading.equalToSuperview().offset(15)
            m.centerY.equalToSuperview()
        }
        
        
        rhsGoB.snp.makeConstraints { (m) in
            m.size.top.equalTo(lhsGoB)
            m.trailing.equalToSuperview().offset(15.neg)
        }
        
        repeatB.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 80, height: 45))
            m.centerY.equalToSuperview().offset(-7)
            m.trailing.equalToSuperview().offset(15.neg)
            
        }
        
       
        intervalB.snp.makeConstraints { (m) in
            m.size.equalTo(repeatB)
            m.centerY.equalTo(repeatB)
            m.leading.equalToSuperview().offset(15)
        }
        
        
        secondPlayB.snp.makeConstraints { (m) in
            m.size.equalTo(repeatB)
            m.centerY.equalTo(repeatB)
            m.centerX.equalToSuperview()
        }
        
        
        lhsPopInterval.snp.makeConstraints { (m) in
            m.size.equalTo(CGSize(width: 75, height: lhsPopInterval.lhsH))
            m.leading.equalToSuperview().offset(15)
            topLhsIntervalConstraint = m.top.equalToSuperview()
        }
        
        
        rhsPopRepeat.snp.makeConstraints { (m) in
            m.size.equalTo(lhsPopInterval)
            m.trailing.equalToSuperview().offset(-15)
            topRhsTimesConstraint = m.top.equalToSuperview()
        }
        
    }
    
    
    
    func doEvents(){
        let tap = UITapGestureRecognizer()
        intervalB.addGestureRecognizer(tap)
        tap.rx.event.bind { (event) in
            self.goPopRhs()
            self.fuckEnIngLhs()
        }.disposed(by: rx.disposeBag)
        
        
        repeatB.rx.tap.subscribe(onNext: { () in
            self.goPopLhs()
            self.riYingTimesRhs()
            
        }).disposed(by: rx.disposeBag)
        
        
        playB.rx.tap.subscribe(onNext: { () in
            self.delegate?.enterPlay()
            self.ggg()
        }).disposed(by: rx.disposeBag)
        
        
        
        lhsGoB.rx.tap.subscribe(onNext: { () in
            self.delegate?.to(page: .lhs)
            self.ggg()
        }).disposed(by: rx.disposeBag)
        
        
        rhsGoB.rx.tap.subscribe(onNext: { () in
            self.delegate?.to(page: .rhs)
            self.ggg()
        }).disposed(by: rx.disposeBag)
        
        
        secondPlayB.rx.tap.subscribe(onNext: { () in
            self.delegate?.secondPlay()
            self.ggg()
        }).disposed(by: rx.disposeBag)
    }
    
    func ggg(){
        goPopRhs()
        goPopLhs()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func p_play(second reallyP: Bool){
        secondPlayB.isSelected = reallyP
    }
    
    func p_startAgain(){
   
        lhsGoB.isHidden = false
        rhsGoB.isHidden = false
        
        repeatB.isHidden = true
        intervalB.isHidden = true
        
        secondPlayB.isHidden = true
        playB.isHidden = false
    }

    
    func p_pause(){
       
        lhsGoB.isHidden = true
        rhsGoB.isHidden = true
        
        
        playB.isHidden = true
        secondPlayB.isHidden = false
        
        repeatB.isHidden = false
        intervalB.isHidden = false
    }
    
    
    
    
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        


        let frameInterval = lhsPopInterval.frame
        
   
        
        let frameTimes = rhsPopRepeat.frame
        
        
        var index = 9
        if bounds.contains(point){
            index = 0
        }
        
        if frameInterval.origin.y < 0, frameInterval.contains(point){
            index = 1
        }
        
        if frameTimes.origin.y < 0, frameTimes.contains(point){
            index = 2
        }
        
        
        switch index {
        case 0:
            for piece in subviews.reversed(){
                let realP = piece.convert(point, from: self)
                let hit = piece.hitTest(realP, with: event)
                if let v = hit{
                    return v
                }
            }
            return self
        case 1:
            if frameInterval.origin.y < 0{
                let realP = lhsPopInterval.convert(point, from: self)
                return lhsPopInterval.hitTest(realP, with: event)
            }
        case 2:
            if frameTimes.origin.y < 0{
                let realP = rhsPopRepeat.convert(point, from: self)
                return rhsPopRepeat.hitTest(realP, with: event)
            }
        default:
            ()
        }
        return nil
    }
}
