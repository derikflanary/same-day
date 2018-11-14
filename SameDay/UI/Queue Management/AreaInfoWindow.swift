//
//  AreaInfoWindow.swift
//  SameDay
//
//  Created by Derik Flanary on 5/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class AreaInfoWindow: UIView {

    static var height: CGFloat = 101.0
    var core = App.sharedCore
    var doneToolbar = CustomInputAccessory()
    var completion: (() -> Void)?
    var area: Area? {
        didSet {
            nameTextField.text = area?.name
        }
    }
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!


    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.cornerRadius = 10
        clipsToBounds = true
        addShadow()
        doneToolbar =  CustomInputAccessory(delegate: self)
        nameTextField.inputAccessoryView = doneToolbar
    }

    @IBAction func deleteButtonTapped() {
        guard let area = area else { return }
        core.fire(event: Deleted(item: area))
        completion?()
    }
    
    @IBAction func editButtonTapped() {
        nameTextField.borderStyle = .roundedRect
        nameTextField.isUserInteractionEnabled = true
        nameTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped() {
        completion?()
    }
    
}

// MARK: - Input accessory delegate

extension AreaInfoWindow: CustomInputAccessoryDelegate {

    func donePressed() {
        endEditing(true)
        nameTextField.isUserInteractionEnabled = false
        nameTextField.borderStyle = .none
        guard let area = area, let name = nameTextField.text else { return }
        var updatedArea = area
        core.fire(event: Updated(item: updatedArea))
    }

}

private extension AreaInfoWindow {

    private func addShadow() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }

}
