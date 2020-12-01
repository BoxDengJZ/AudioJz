//
//  SortAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/22.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit


extension Array where Element == IndexPath{
    
    var sortPair: (big: IndexPath, small: IndexPath){
        get{
            let result = sorted(by: {  $0.row > $1.row })
            return (result[0], result[1])
        }
    }
}



extension Collection{
    var exists: Bool{
        isEmpty == false
    }
}


extension Optional where Wrapped: Collection {
    var exists: Bool{
        if let sth = self, sth.isEmpty == false{
            return true
        }
        else{
            return false
        }
    }
}
