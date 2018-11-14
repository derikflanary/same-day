//
//  NewAreaView.swift
//  SameDay
//
//  Created by Derik Flanary on 5/25/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import CoreLocation

class NewAreaView: UIView {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    static let height: CGFloat = 116
    var name: String?
    var coordinate: CLLocationCoordinate2D?
    var core = App.sharedCore
    var completion: (() -> Void)?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.cornerRadius = 10
        clipsToBounds = true
        addShadow()
    }

    func update(with name: String?, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
        nameTextField.text = name
    }


    @IBAction func textFieldChanged(_ sender: UITextField) {
        name = nameTextField.text
    }

    @IBAction func cancelButtonTapped() {
        completion?()
    }

    @IBAction func saveButtonTapped() {
        guard let name = name, let coordinate = coordinate else { return }
    }

}

private extension NewAreaView {

    private func addShadow() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }

}


