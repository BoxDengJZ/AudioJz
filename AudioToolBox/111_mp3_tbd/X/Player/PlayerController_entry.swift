//
//  ViewController.swift
//  petit
//
//  Created by Jz D on 2020/10/16.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


import AVFoundation


import RxSwift
import RxCocoa

import NSObject_Rx

import SnapKit


struct LayoutWoX {
    
    static let std = LayoutWoX()
    
    let x: CGFloat
    
    let wid: CGFloat
    let height: CGFloat = 100
    
    init() {
        x = UI.std.width * 0.53
        
        wid = UI.std.width - x - 15
    }

}



class PlayerController: UIViewController{
    
    
    var playingSelected = false
    
    
    var audioStream: Streamer?
    
    lazy var bottomBoard : BottomPlayV = {
        let b = BottomPlayV()
        b.delegate = self
        return b
    }()
    
    lazy var progressV: PlayerProgressBar = {
        let v = PlayerProgressBar()
        v.delegate = self
        return v
    }()
    
    
    var bottomChoosePopConstraint: ConstraintMakerEditable?
    var heightChangeChoosePopConstraint: ConstraintMakerEditable?
    

    let pIntelliJ_std: P_intelligence
    
    var fileP: String = ""

    var durationPropaganda: TimeInterval?

    lazy var calibrationView = CalibrationV()
  
    
    lazy var showTipLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.regular(ofSize: 18)
        l.textColor = UIColor.magenta
        l.isHidden = false
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    var currentIdx = -1
    
    let src: String
    
    init(from source: String) {
        src = source
        
        var temp: P_intelligence?
        do{
            if let path = Bundle.main.url(forResource: src, withExtension: "json"){
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let info = try decoder.decode([NodeK].self, from: data)
                temp = P_intelligence(list: info)
            }
        }
        catch let error as NSError{
            print(error)
        }
        
        guard let dat = temp else {
            fatalError()
        }
        
        pIntelliJ_std = dat
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = UIColor(rgb: 0xF9F9F9)

        title = src
        forUI()
   
        forEvents()

        showMediaInfo()
    
        preparePlay()

        
        
        
    }

    

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioStream?.sourceURL = nil
    }
    
    
    func forUI(){
        
        
        view.addSubs([ progressV, calibrationView,
                       showTipLabel, bottomBoard ])
      
 
        bottomBoard.snp.makeConstraints { (m) in
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(80 + bottomBoard.niMaH)
            m.bottom.equalToSuperview()
        }
        
        progressV.snp.makeConstraints { (m) in
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(progressV.h)
            m.bottom.equalTo(bottomBoard.snp.top)
        }

        calibrationView.snp.makeConstraints { (m) in
            m.leading.trailing.equalTo(progressV.progressBar)
            m.height.equalTo(12)
            m.bottom.equalTo(progressV.snp.top)
        }
        let leading: CGFloat = 80
        
        showTipLabel.snp.makeConstraints { (m) in
            m.leading.equalToSuperview().offset(leading)
            m.trailing.equalToSuperview().offset(leading.neg)
            m.top.equalToSuperview().offset(110)
            m.bottom.equalToSuperview().offset(200.neg)
        }
    }
    
    
    
    
    func forEvents(){
        
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            })
        }
    }


    
    func config(duration t: Double){
        progressV.config(total: t)
    }
    
    
    func update(metric value: Float){
        let pie = pIntelliJ_std.list
       
        let val = Double(value)
        var i = 0
        for element in pie{
            if val > element.time{
                
                // 这里有一个过滤
                if currentIdx != i{
                    currentIdx = i
                    showTipLabel.text = element.sentence
                }
                break
            }
            else{
                i += 1
            }
        }
        
        
    }
}





