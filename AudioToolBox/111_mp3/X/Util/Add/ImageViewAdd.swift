//
//  ImageViewAdd.swift
//  musicSheet
//
//  Created by Jz D on 2019/9/16.
//  Copyright © 2019 Jz D. All rights reserved.
//

import UIKit

class ImageView: UIImageView, ExpressibleByStringLiteral{
    public convenience required init(stringLiteral value: String) {
        self.init(image: UIImage(named: value))
    }
}


class Label: UILabel, ExpressibleByStringLiteral{
    public convenience required init(stringLiteral value: String) {
        self.init(frame: CGRect.zero)
        text = value
    }
}




extension UIView {

    var asImg: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
