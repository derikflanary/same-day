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
        // Initialization code
    }

    func configure(with job: Job, isSelected: Bool) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        startTimeLabel.text = formatter.string(from: job.date)
        let time = Calendar.current.date(byAdding: .hour, value: job.duration, to: job.date)
        endTimeLabel.text = formatter.string(from: time!)
        titleLabel.text = job.title

        selectedView.isHidden = !isSelected
    }
    
}
