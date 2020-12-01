//
//  CellAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/21.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import UIKit


protocol CellReuse {
    static var id: String {get}
}



extension UITableViewCell: CellReuse{
    static var id: String{
        return String(describing: self)
        
    }
    
    
    static let placeHolder = UITableViewCell()

}



extension UICollectionReusableView: CellReuse{
    static var id :String {
        String(describing: self)
    }
}
    
extension UICollectionReusableView{
    static let header = "UICollectionElementKindSectionHeader"
    
    static let footer = "UICollectionElementKindSectionFooter"
    
    static let addTop = "addTop"
    
    static let placeHolder = UICollectionReusableView()
}


extension UICollectionViewCell{
    
    static let place = UICollectionViewCell()
}
