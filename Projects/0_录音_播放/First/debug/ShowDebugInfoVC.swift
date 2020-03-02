
//
//  ShowDebugInfoVC.swift
//  First
//
//  Created by Jz D on 2020/3/2.
//  Copyright © 2020 dengjiangzhou. All rights reserved.
//

import UIKit

class ShowDebugInfoVC: UIViewController {
    
    
    
    @IBOutlet weak var tipLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let proxy = UIApplication.shared.delegate as? AppDelegate, let word = proxy.debugInput{
            tipLabel.text = word
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
