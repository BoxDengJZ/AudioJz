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

enum LanOpt{
    case en
    case ch
    
    
    var val: String{
        let src: String
        switch self {
        case .ch:
            src = "chinese"
        case .en:
            src = "english"
        }
        return src
    }
}

enum EnterP_src{
    case std(PlayPageHa)
    case custom(Int, LanOpt)
}



struct PlayPageHa {
    let kind: LanOpt
    let k: Int
}



enum FileFormat{
 
    static let pcm = "wav"
}




let assetDir: URL = {
  let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()





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
    

    var pIntelliJ_std: P_intelligence?
    
    var fileP: String = ""

    var durationPropaganda: TimeInterval?

    lazy var calibrationView = CalibrationV()
  
    
    lazy var showTipLabel: UILabel = {
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        l.font = UIFont.regular(ofSize: 16)
        l.textColor = UIColor.magenta
        l.isHidden = true
        l.textAlignment = .center
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = UIColor(rgb: 0xF9F9F9)

        
        forUI()
   
        forEvents()
        
        
        do{
            if let path = Bundle.main.url(forResource: "one", withExtension: "plist"){
                let data = try Data(contentsOf: path)
                let decoder = PropertyListDecoder()
                let info = try decoder.decode(P_intelligence.self, from: data)
                self.pIntelliJ_std = info
                
                
            }
        }
        catch let error as NSError{
            print(error)
        }


        
        
        showMediaInfo()
    
        preparePlay()

        
        
        guard let cake = pIntelliJ_std?.oreoPercent else {
            
            return
        }
        
        
        calibrationView.tubes = cake
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showTipLabel.frame.origin.y = calibrationView.frame.origin.y - 60
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
        
        if let pie = pIntelliJ_std?.see, let rvc = pIntelliJ_std?.oreoPercent, let duration = durationPropaganda{
            let val = Double(value)
            var toHide = true
            var i = 0
            for element in pie.node{
                if fabs(pie.wav_lengths[element.index] - val) < 2{
                    toHide = false
                    showTipLabel.text = element.title
                    showTipLabel.isHidden = false
                    showTipLabel.center.x = progressV.progressBar.chase(percent: rvc[i])
                    showTipLabel.sizeToFit()
                }
                i += 1
            }
            if toHide || abs(duration - val) <= 0.8{
                showTipLabel.isHidden = true
            }
        }
    }
}





