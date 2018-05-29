//
//  CustomInputAccessoryView.swift
//  greatwork
//
//  Created by Derik Flanary on 7/20/16.
//  Copyright © 2016 OC Tanner Company, Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol CustomInputAccessoryDelegate {
    func customButtonPressed()
    func donePressed()
}

open class CustomInputAccessory: UIView {

    // MARK: - Public properties

    open var customButtonTitle: String?


    // MARK: - Private properties

    fileprivate var delegate: CustomInputAccessoryDelegate?
    fileprivate var textInput: UIView?
    fileprivate let toolbar = UIToolbar()
    fileprivate var textInputViews = [UITextInput]()
    fileprivate var isTabbable = false
    fileprivate let fixedSpaceWidth: CGFloat = 12
    fileprivate let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(CustomInputAccessory.doneTouched))


    // MARK: - Initializers

    convenience public init(textInput: UIView?) {
        self.init(frame: CGRect.zero)
        self.textInput = textInput
        setupViews()
    }

    convenience public init(delegate: CustomInputAccessoryDelegate, customButtonTitle: String? = nil) {
        self.init(frame: CGRect.zero)
        self.customButtonTitle = customButtonTitle
        self.delegate = delegate
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

}


// MARK: - Internal functions

extension CustomInputAccessory {

    @objc func doneTouched() {
        if let delegate = delegate {
            delegate.donePressed()
        } else if let textInput = textInput {
            textInput.resignFirstResponder()
        }
    }

    @objc func customButtonTouched() {
        delegate?.customButtonPressed()
    }

}


// MARK: - Private functions

private extension CustomInputAccessory {

    func setupViews() {
        let toolbarSize = toolbar.sizeThatFits(toolbar.frame.size)
        toolbar.frame = CGRect(x: 0, y: 0, width: toolbarSize.width, height: toolbarSize.height)
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frame = toolbar.frame

        var buttons: [UIBarButtonItem]
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        if let customButtonTitle = customButtonTitle {
            let customButton = UIBarButtonItem(title: customButtonTitle, style: .plain, target: nil, action: #selector(CustomInputAccessory.customButtonTouched))
            buttons = [customButton, flexibleSpace, doneButton]
        } else {
            buttons = [flexibleSpace, doneButton]
        }

        toolbar.items = buttons
        addSubview(toolbar)
    }

}


extension CustomInputAccessoryDelegate {

    func customButtonPressed() {
        return
    }

}
