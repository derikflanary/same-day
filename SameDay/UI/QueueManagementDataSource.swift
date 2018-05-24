//
//  QueueManagementDataSource.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class QueueManagementDataSource: NSObject, UITableViewDataSource {

    var areas = [Area]()

    func numberOfSections(in tableView: UITableView) -> Int {
        return areas.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return areas[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas[section].users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as UserCell
        let area = areas[indexPath.section]
        let user = area.users[indexPath.row]
        cell.configure(with: user)
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let userToMove = areas[sourceIndexPath.section].users[sourceIndexPath.row]
        areas[sourceIndexPath.section].users.remove(at: sourceIndexPath.row)
        areas[destinationIndexPath.section].users.insert(userToMove, at: destinationIndexPath.row)
        App.sharedCore.fire(event: Loaded(items: areas))
    }

}
