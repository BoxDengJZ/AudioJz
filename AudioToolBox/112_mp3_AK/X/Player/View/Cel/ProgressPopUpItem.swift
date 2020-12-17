//
//  ProgressPopUpItem.swift
//  petit
//
//  Created by Jz D on 2020/11/3.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class ProgressPopUpItem: UITableViewCell {
    
    
    
    
    
    
    @IBOutlet weak var title: UILabel!
    
    
    
    
    
    func config(header t: String){
        title.text = t

        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
