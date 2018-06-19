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

    var jobs = [Job]()
    var selectedJob: Job?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as JobCell
        let job = jobs[indexPath.row]
        let isSelected = selectedJob == job
        cell.configure(with: job, isSelected: isSelected)
        return cell
    }

}
