//
//  OptionsViewController.swift
//  PenguinPet
//
//  Created by Michael Briscoe on 12/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import AVFoundation


protocol OptionsViewControllerDelegate: class{
    func doPlay()
}

class OptionsViewController: UIViewController {
  
  @IBOutlet weak var pitchSlider: UISlider!
  @IBOutlet weak var rateSlider: UISlider!
  @IBOutlet weak var textMessage: UITextView!
  
  weak var delegate: OptionsViewControllerDelegate?
  
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override func viewDidLoad() {
     super.viewDidLoad()
     defaults()
  }
  
   override var prefersStatusBarHidden: Bool{
      return true
   }
  

   @IBAction func dis(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
    
  @IBAction func adjustPitch(_ sender: UISlider) {
      UserSetting.shared.pitch = sender.value
  }
  
  func storeTextMessage() {
     UserSetting.shared.message = textMessage.text
     delegate?.doPlay()
  }
  
    
  @IBAction func adjustRate(_ sender: UISlider) {
     UserSetting.shared.rate = sender.value
  }
    
    
    
  @IBAction func previewAudio(_ sender: Any) {
      storeTextMessage()
  }
    
    
  @IBAction func resetAudio(_ sender: UIButton) {
     UserSetting.shared.reset()
     defaults()
  }
    
    
  func defaults(){
    pitchSlider.value = UserSetting.shared.pitch
    rateSlider.value = UserSetting.shared.rate
    textMessage.text = UserSetting.shared.message
  }
}



extension OptionsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
          storeTextMessage()
          textView.resignFirstResponder()
          return false
        }
        return true
  }
}

