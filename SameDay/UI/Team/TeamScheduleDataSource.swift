//
//  TeamScheduleDataSource.swift
//  SameDay
//
//  Created by Derik Flanary on 7/5/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class TeamScheduleDataSource: NSObject, UITableViewDataSource {

    var employees = [Employee]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Unassigned"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as UserCell
        let employee = employees[indexPath.row]
        cell.configure(with: employee)
        return cell
    }

}
