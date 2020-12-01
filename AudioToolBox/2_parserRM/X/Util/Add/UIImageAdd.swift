//
//  UIImageAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/9.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit

extension UIImage{    
    var aspestRatio: CGFloat{
        return size.height/size.width
    }
    
    
    static let defaultRatio: CGFloat = 1.0/6.0
}



extension UIImage{



    static func qrCode(info txt: String) -> UIImage?{
        let data = txt.data(using: String.Encoding.utf8)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
        
    }




}



extension UIImage{
    var disabled: UIImage?{
        let ciImage = CIImage(image: self)
        let grayscale = ciImage?.applyingFilter("CIColorControls",
                                                parameters: [ kCIInputSaturationKey: 0.0 ])
        if let gray = grayscale{
            return UIImage(ciImage: gray)
        }
        else{
            return nil
        }
    }
}




extension UIImage{
    /// Create a grayscale image with alpha channel. Is 5 times faster than grayscaleImage().
    /// - Returns: The grayscale image of self if available.
    var grayScaled: UIImage?
    {
        // Create image rectangle with current image width/height * scale
        let pixelSize = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let imageRect = CGRect(origin: CGPoint.zero, size: pixelSize)
        // Grayscale color space
        
        
        // 核心方法，是通过颜色空间
         let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()

            // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        if let context: CGContext = CGContext(data: nil, width: Int(pixelSize.width), height: Int(pixelSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
            {
                // Draw image into current context, with specified rectangle
                // using previously defined context (with grayscale colorspace)
                guard let cg = self.cgImage else{
                    return nil
                }
                context.draw(cg, in: imageRect)
                // Create bitmap image info from pixel data in current context
                if let imageRef: CGImage = context.makeImage(){
                    let bitmapInfoAlphaOnly = CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue)

                    guard let context = CGContext(data: nil, width: Int(pixelSize.width), height: Int(pixelSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfoAlphaOnly.rawValue) else{
                        return nil
                    }
                    context.draw(cg, in: imageRect)
                    if let mask: CGImage = context.makeImage() {
                        // Create a new UIImage object
                        if let newCGImage = imageRef.masking(mask){
                            // Return the new grayscale image
                            return UIImage(cgImage: newCGImage, scale: self.scale, orientation: self.imageOrientation)
                        }
                    }

                }
            }


        // A required variable was unexpected nil
        return nil
    }
}



