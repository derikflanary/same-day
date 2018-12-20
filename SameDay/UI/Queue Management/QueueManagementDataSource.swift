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
    var users = [User]()

    var unassignedUsers: [User] {
        return users
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return areas.count + 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Unassigned Techs"
        default:
            return areas[section - 1].name
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return unassignedUsers.count
        default:
            break
//            return areas[section - 1].users.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as UserCell
        var user: User
        switch indexPath.section {
        case 0:
            user = unassignedUsers[indexPath.row]
        default:
            let area = areas[indexPath.section - 1]
//            user = area.users[indexPath.row]
        }
//        cell.configure(with: user)
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var userToMove: User
        switch sourceIndexPath.section {
        case 0:
            userToMove = unassignedUsers[sourceIndexPath.row]
        default:
            break
//            userToMove = areas[sourceIndexPath.section - 1].users[sourceIndexPath.row]
//            areas[sourceIndexPath.section - 1].users.remove(at: sourceIndexPath.row)
        }

        switch destinationIndexPath.section {
        case 0:
            break
        default:
            break
//            areas[destinationIndexPath.section - 1].users.insert(userToMove, at: destinationIndexPath.row)
        }

        App.sharedCore.fire(event: Loaded(object: areas))
    }

}
