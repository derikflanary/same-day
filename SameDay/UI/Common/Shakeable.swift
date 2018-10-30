//
//  Shakeable.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import UIKit

protocol Shakeable { }

// we can constrain the shake method to only UIViews!
extension Shakeable where Self: UIView {

    // default shake implementation
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 4, y: center.y)
        let toPoint = CGPoint(x: center.x + 4, y: center.y)
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        layer.add(animation, forKey: "position")
    }
}
