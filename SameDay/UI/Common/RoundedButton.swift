//
//  RoundedButton.swift
//  greatwork
//
//  Created by Derik Flanary on 9/23/18.
//  Copyright © 2018 OC Tanner Company, Inc. All rights reserved.
//

import UIKit

@IBDesignable open class RoundedButton: UIButton {

    enum RoundedEdgeType: CGFloat {
        case simple = 8
        case soft = 3
        case full = 2
        case none = 0
    }

    var roundedEdgeType: RoundedEdgeType = .simple {
        didSet {
            updateEdges()
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.10) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 1.02, y: 1.02) : .identity
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }

    @IBInspectable open var isShadowed: Bool = false {
        didSet {
            if isShadowed {
                addShadow()
            } else {
                removeShadow()
            }
        }
    }

    override open var isEnabled: Bool {
        didSet {
            if isEnabled {
                alpha = 1.0
            } else {
                alpha = 0.2
            }
        }
    }

    override open var isSelected: Bool {
        didSet {
            updateBorders()
        }
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateEdges()
        addShadow()
        tintColor = .clear
    }


    private func updateEdges() {
        switch roundedEdgeType {
        case .simple, .soft, .full:
            layer.cornerRadius = frame.height / roundedEdgeType.rawValue
        case .none:
            layer.cornerRadius = 0
        }
        clipsToBounds = true
    }

    private func updateBorders() {
        if isSelected {
            layer.borderWidth = 3.0
            layer.borderColor = UIColor.secondary.cgColor
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
    }

    override open func setTitle(_ title: String?, for state: UIControl.State) {
        let upTitle = title?.uppercased()
        super.setTitle(upTitle, for: state)
    }

    private func addShadow() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }

    private func removeShadow() {
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 0.0
        layer.masksToBounds = true
    }

}
