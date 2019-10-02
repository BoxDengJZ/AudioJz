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
    func toSetPan(value: Float)
    func toSetRate(value: Float)
    func toSetLoopPlayback(loop: Bool)
}

let kVolume = "Volume"

class OptionsViewController: UIViewController {
    
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var panSlider: UISlider!
    @IBOutlet weak var rateSlider: UISlider!
    
    @IBOutlet weak var loopSwitch: UISwitch!
    
    weak var delegateOptionsViewController: OptionsViewControllerDelegate?
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        volumeSlider.value = defaults.float(forKey: kVolume)
        panSlider.value = defaults.float(forKey: "Pan")
        rateSlider.value = defaults.float(forKey: "Rate")
        loopSwitch.isOn = defaults.bool(forKey: "Loop Audio")
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK:- 右边的仪表盘 IBActions
    
    @IBAction func toSetVolume(_ sender: UISlider) {
        defaults.set(sender.value, forKey: "Volume")
        delegateOptionsViewController?.toSetVolumn(value: sender.value)
    }
    
    @IBAction func toSetPan(_ sender: UISlider) {
        defaults.set(sender.value, forKey: "Pan")
        delegateOptionsViewController?.toSetPan(value: sender.value)
    }
    
    @IBAction func toSetRate(_ sender: UISlider) {
        defaults.set(sender.value, forKey: "Rate")
        delegateOptionsViewController?.toSetRate(value: sender.value)
    }
    
    @IBAction func loopAudio(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "Loop Audio")
        delegateOptionsViewController?.toSetLoopPlayback(loop: sender.isOn)
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
