//
//  PopChooseCel.swift
//  petit
//
//  Created by Jz D on 2020/10/28.
//  Copyright © 2020 swift. All rights reserved.
//

import UIKit

class PopChooseCel: UITableViewCell {

    
    
    @IBOutlet weak var content: UILabel!
    
    
    
    func config(title name: String){
        content.text = name
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content.textAlignment = .center
        
        content.font = UIFont.semibold(ofSize: 12)
        
        content.backgroundColor = UIColor(rgb: 0x575A61)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
