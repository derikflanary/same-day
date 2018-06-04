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

    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectedView: UIView!

    override func didMoveToWindow() {
        selectedView.layer.cornerRadius = selectedView.frame.height / 2
        selectedView.clipsToBounds = true
        todayView.layer.cornerRadius = todayView.frame.height / 3
        todayView.clipsToBounds = true
        todayView.layer.borderWidth = 2.0
    }

    func configure(with date: Date, cellState: CellState, datesWithJobs: [Date], selectedDate: Date) {
        dayLabel.text = cellState.text
        weekDayLabel.text = date.dayOfWeek()
        if cellState.dateBelongsTo == .thisMonth {
            dayLabel.textColor = .blackOne
            weekDayLabel.textColor = .blackOne
        }
        selectedView.isHidden = !datesWithJobs.contains(where: { Calendar.current.isDate($0, inSameDayAs: date)})

        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            dayLabel.font = UIFont.boldSystemFont(ofSize: 14)
            weekDayLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        } else {
            dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
            weekDayLabel.font = UIFont.systemFont(ofSize: 14, weight: .ultraLight)
        }

        if Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            todayView.layer.borderColor = UIColor.theme.cgColor
        } else {
            todayView.layer.borderColor = UIColor.clear.cgColor
        }

    }
}
