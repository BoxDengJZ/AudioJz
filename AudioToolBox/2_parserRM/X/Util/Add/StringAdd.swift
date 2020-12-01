//
//  StringAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/8/23.
//  Copyright © 2019 上海莫小臣有限公司. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func range(_ inner: String) -> NSRange{
        return (self as NSString).range(of: inner)
    }
    
    func range(_ inner: Int) -> NSRange{
        return (self as NSString).range(of: "\(inner)")
    }

    func rangeTagged(_ inner: String, offset: Int = 2) -> NSRange{
        let range = (self as NSString).range(of: inner)
        return NSRange(location: range.location, length: range.length - offset)
    }
    // 添加两个字符
    
    
    var fullRange: NSRange{
        return NSRange(location: 0, length: count)
    }
    
    
    func board(){
        UIPasteboard.general.string = self
    }
}



struct Search {
    static let history = "Search_history"
}



extension String{
    
    var imageRatio: CGFloat {
        get{
            if let image = UIImage(named: self){
                return image.aspestRatio
            }
            return UIImage.defaultRatio
        }
    }
    
    
    var valid: Bool{
        self != ""
    }
    
    
}




enum MusicSource{
    case piano
    case violin
    case tbd
}





extension String {
    func removing(charactersOf string: String) -> String {
        
        let characterSet = CharacterSet(charactersIn: string)
        let compo = components(separatedBy: characterSet)
        return compo.joined(separator: "")
    }
    
    var pruned: String{
        trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
}



extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    
    
    
}

//  https://stackoverflow.com/questions/24051314/precision-string-format-specifier-in-swift






extension Float {

    var formatted: String {
        return String(format: "%0.1f", self)
    }


}




extension String {
  
    
    
    var writer: String{
        let path = "\(URL.dir)/\(self)"
        if FileManager.default.fileExists(atPath: path) == false{
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return path
    }
    
    
}








extension URL{
  
    
    static var dir: String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
        
    
}


//  https://www.youtube.com/watch?v=vSKL1QUo_b0

extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    
    var scalarDng: Int{
        Int(westernArabicNumeralsOnly) ?? 0
    }
}
