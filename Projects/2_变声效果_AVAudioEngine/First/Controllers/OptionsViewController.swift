//
//  OptionsViewController.swift
//  First
//
//  Created by dengjiangzhou on 2018/6/7.
//  Copyright © 2018年 dengjiangzhou. All rights reserved.
//

import UIKit

protocol OptionsViewControllerDelegate: class{
    func play()
    func toSetVolumn(value: Float)
    func toSetPitch(value: Float)
    func toSetRate(value: Float)
    func toSetReverb(value: Float)
}

let kVolume = "Volume"

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var rateSlider: UISlider!
    
    weak var delegateOptionsViewController: OptionsViewControllerDelegate?
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        volumeSlider.value = UserSetting.shared.volume
        rateSlider.value = UserSetting.shared.rate
        reverbSlider.value = UserSetting.shared.reverb
        pitchSlider.value = UserSetting.shared.pitch
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK:- 右边的仪表盘 IBActions
    
    @IBAction func toSetVolume(_ sender: UISlider) {
        UserSetting.shared.volume = sender.value
        delegateOptionsViewController?.toSetVolumn(value: sender.value)
    }
    
    @IBAction func toSetPitch(_ sender: UISlider) {
        UserSetting.shared.pitch = sender.value
        delegateOptionsViewController?.toSetPitch(value: sender.value)
    }
    
    @IBAction func toSetRate(_ sender: UISlider) {
        UserSetting.shared.rate = sender.value
        delegateOptionsViewController?.toSetRate(value: sender.value)
    }
    
    @IBAction func toSetReverb(_ sender: UISlider) {
        UserSetting.shared.reverb = sender.value
        delegateOptionsViewController?.toSetReverb(value: sender.value)
    }
    
    // MARK:- 下面的 Button Actions
    
    @IBAction func closeOptions(_ sender: UIButton) {
        dismiss(animated: true){}
    }
    
    @IBAction func previewAudio(_ sender: UIButton) {
        delegateOptionsViewController?.play()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
