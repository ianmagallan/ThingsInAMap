//
//  UIImage+flippedHorizontally.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import UIKit

extension UIImage {
    var flippedHorizontally: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -size.width / 2, y: -size.height / 2)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
