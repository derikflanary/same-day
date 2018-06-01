//
//  CellView.swift
//  SameDay
//
//  Created by Derik Flanary on 5/31/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell, ReusableView {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!

    @IBOutlet weak var selectedView: UIView!

    override func didMoveToWindow() {
        selectedView.layer.cornerRadius = selectedView.frame.height / 2
        selectedView.clipsToBounds = true
    }
}
