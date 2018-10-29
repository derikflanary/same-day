//
//  AppointmentCell.swift
//  SameDay
//
//  Created by Derik Flanary on 6/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class AppointmentCell: UICollectionViewCell, ReusableView {

    static var height: CGFloat = 152

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var windowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        clipsToBounds = true
        addShadow()
    }

    func configure(with appointment: Appointment) {
        let account = appointment.invoice.account
        nameLabel.text = account.displayName
        addressLabel.text = account.addressString
        dateLabel.text = appointment.displayStartDateAndTime
        windowLabel.text = appointment.displayEndDateAndTime
    }

}

private extension AppointmentCell {

    private func addShadow() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.masksToBounds = false
    }
}
