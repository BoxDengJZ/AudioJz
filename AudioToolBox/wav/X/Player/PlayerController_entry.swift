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


struct OutputPlay {
    var pIntelliJ_std: P_intelligence?
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
    

    var info: ReadableDat?
    
    
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
    

    var renderDat = OutputPlay()
    
    var fileP: String = ""

    var durationPropaganda: TimeInterval?

    
  
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
                self.renderDat.pIntelliJ_std = info
            }
        }
        catch let error as NSError{
            print(error)
        }


        
        
        showMediaInfo()
    
        preparePlay()

    }

    
    
    
    func forUI(){
        
        
        view.addSubs([ progressV, bottomBoard])
      
 
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
    
    
    

}





