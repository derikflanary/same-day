//
//  ReuseableView.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: Bundle.main)
    }

}
