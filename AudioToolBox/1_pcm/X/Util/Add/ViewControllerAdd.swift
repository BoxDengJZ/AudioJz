
//
//  ViewController.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/25.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit



extension UIViewController{
    
    

    func config(_ name: String, imageName image: String, selectedImageName selectedImage: String){
        tabBarItem.title = name
        tabBarItem.image = UIImage(named: image)
        tabBarItem.selectedImage = UIImage(named: selectedImage)
        
    }
    //
    
    /*
    
    func hideBottomBar(){
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.adjustLayout(false)
        }
    }
    
    
    func showBottomBar(){
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.adjustLayout()
        }
    }
    
    //
    

    
    
  
    
    
    func addLoginIAP_refuse(){
        
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.addIAP_refuseCtrl()
            
        }
    }
    
    
    
    
    func removeLoginController(){
        Base.timer?.cancel()
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.rmLoginCtrl()
        }
    }
    
    //
 
    func editLoginController(){
        NotificationCenter.default.post(name: .quit_login, object: nil)
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.editPasswordLoginCtrl()
        }
    }
    
    
    */
}



/*

extension UIViewController{

    func enterPush(src mencius: Mencius){
        
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.innerPushC(src: mencius)
        }
    }
    
    
    
    func enterActivity(src mulan: String){
        
        let controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        if let tab = controller as? TabBarViewController{
            tab.gotoActivity(opt: mulan)
        }
    }



}
*/
