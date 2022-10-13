//
//  UIView.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 12.10.22.
//

import Foundation
import UIKit

extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
}
