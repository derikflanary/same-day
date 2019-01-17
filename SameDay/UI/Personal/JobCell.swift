//
//  JobCell.swift
//  SameDay
//
//  Created by Derik Flanary on 6/1/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell, ReusableView {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var selectedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedView.layer.cornerRadius = selectedView.frame.height / 2
        selectedView.clipsToBounds = true
    }

    func configure(with appointment: Appointment, isSelected: Bool) {
        titleLabel.text = appointment.displayName
        addressLabel.text = appointment.addressString
        selectedView.isHidden = !isSelected
        switch appointment.result {
        case .completed:
            startTimeLabel.text = appointment.result.rawValue
            endTimeLabel.text = ""
            contentView.backgroundColor = UIColor.grayThree
//            accessoryType = .none
        default:
            startTimeLabel.text = appointment.displayStartTime
            endTimeLabel.text = appointment.displayEndTime
            contentView.backgroundColor = .white
            accessoryType = .detailButton
        }
    }
    
}
