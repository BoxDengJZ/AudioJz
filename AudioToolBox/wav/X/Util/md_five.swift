//
//  md_five.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/11.
//  Copyright © 2019 Jz D. All rights reserved.
//

import Foundation


import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


extension String{
    
    
    var md_five: String{
        get{
            
            let length = Int(CC_MD5_DIGEST_LENGTH)
            let messageData = data(using:.utf8)!
            var digestData = Data(count: length)
            
            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            
            return digestData.map { String(format: "%02hhx", $0) }.joined()
        }
        
        
        
        
    }
    
    
    
}
