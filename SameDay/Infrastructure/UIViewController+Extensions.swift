//
//  UIViewController+Extensions.swift
//  SameDay
//
//  Created by Derik Flanary on 7/3/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

extension UIViewController {

    func showAlert(title: String, message: String?, image: UIImage?, completion: (() -> Void)?) {
        var attributes = EKAttributes()
        attributes.position = .bottom
        attributes.displayDuration = 3
        attributes.screenInteraction = .forward
        attributes.roundCorners = .all(radius: 10)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        attributes.entryBackground = .gradient(gradient: .init(colors: [.theme, .whiteOne], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        attributes.positionConstraints.size = .init(width: widthConstraint, height: EKAttributes.PositionConstraints.Edge.intrinsic)
        attributes.lifecycleEvents.didDisappear = completion

        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.boldSystemFont(ofSize: 16), color: .darkGray))
        let description = EKProperty.LabelContent(text: message ?? "", style: .init(font: UIFont.systemFont(ofSize: 14), color: .darkGray))
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }

}

extension EKAttributes {

    mutating func addDefaultBottomAttributes() {
        position = .bottom
        displayDuration = .infinity
        screenInteraction = .dismiss
        roundCorners = .all(radius: 10)
        shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero))
        entryBackground = .color(color: .whiteOne)
        screenBackground = .color(color: UIColor(white: 0.5, alpha: 0.5))
        popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        hapticFeedbackType = .success
    }
}
