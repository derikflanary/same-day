//
//  TeamScheduleViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 7/5/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import SwiftEntryKit

class TeamScheduleViewController: UIViewController {

    var core = App.sharedCore
    var datePicker = UIDatePicker(frame: .zero)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataSource: TeamScheduleDataSource!
    @IBOutlet weak var dateButton: UIButton!

    override func viewDidLoad() {
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: 100))
        datePicker.date = Date()
        dateButton.setTitle(datePicker.date.weekDayMonthDayString(), for: .normal)
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    @objc func datePickerValueChanged() {
        dateButton.setTitle(datePicker.date.weekDayMonthDayString(), for: .normal)
    }

    @IBAction func dateButtonTapped() {
        showDatePicker()
    }
}


private extension TeamScheduleViewController {

    func showDatePicker() {
        var attributes = EKAttributes()
        attributes.addDefaultBottomAttributes()
        SwiftEntryKit.display(entry: datePicker, using: attributes)
    }

}


// MARK: - Subscriber

extension TeamScheduleViewController: Subscriber {

    func update(with state: AppState) {
        guard let currentUser = state.userState.currentUser else { return }
        dataSource.employees = currentUser.employees
        tableView.reloadSections([0], with: .automatic)
    }

}
