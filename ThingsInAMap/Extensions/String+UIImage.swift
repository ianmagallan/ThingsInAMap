//
//  String+UIImage.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import UIKit

extension String {
    var image: UIImage {
        let fontSize = 16.0
        let font = UIFont.systemFont(ofSize: fontSize)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: stringAttributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            UIColor.clear.set()
            let rect = CGRect(origin: .zero, size: size)
            UIRectFill(rect)
            (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        }
    }
}
