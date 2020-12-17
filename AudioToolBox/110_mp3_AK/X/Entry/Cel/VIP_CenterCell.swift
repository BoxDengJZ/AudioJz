//
//  VIP_CenterCell.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/26.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit



class VIP_CenterCell: UITableViewCell {
    
    
    @IBOutlet weak var lhs: UILabel!


    func configTail(_ left: String){
    
        lhs.text = left
        
        lhs.font = UIFont.regular(ofSize: 18)
        lhs.textColor = UIColor(rgb: 0x515151)
       
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
