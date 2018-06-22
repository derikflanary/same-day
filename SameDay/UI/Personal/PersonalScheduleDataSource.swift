//
//  PersonalScheduleDataSource.swift
//  SameDay
//
//  Created by Derik Flanary on 6/1/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import UIKit

class PersonalScheduleDataSource: NSObject, UITableViewDataSource {

    var appointments = [Appointment]()
    var selectedAppointment: Appointment?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as JobCell
        let appointment = appointments[indexPath.row]
        let isSelected = selectedAppointment == appointment
        cell.configure(with: appointment, isSelected: isSelected)
        return cell
    }

}
