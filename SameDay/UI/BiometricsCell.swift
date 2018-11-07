//
//  BiometricsCell.swift
//  SameDay
//
//  Created by Derik Flanary on 11/7/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class BiometricsCell: UITableViewCell, ReusableView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var switcher: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with biometricsEnabled: Bool) {
        switcher.isOn = biometricsEnabled
        title.text = BiometricAuthenticator.sharedInstance.biometryType?.biometryTypeString
    }

    @IBAction func switcherValueChanged(_ sender: UISwitch) {
        BiometricAuthenticator.sharedInstance.biometryIsEnabled = switcher.isOn
    }

}
