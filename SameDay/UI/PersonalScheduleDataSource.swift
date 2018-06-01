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
    var selectedIndex: IndexPath?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as JobCell
        cell.configure(with: jobs[indexPath.row], isSelected: selectedIndex == indexPath)
        return cell
    }

}
