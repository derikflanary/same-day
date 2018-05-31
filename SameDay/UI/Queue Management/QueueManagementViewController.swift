//
//  QueueManagementViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 5/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class QueueManagementViewController: UIViewController {

    @IBOutlet var dataSource: QueueManagementDataSource!
    @IBOutlet weak var tableView: UITableView!

    var core = App.sharedCore

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
        dataSource.users = core.state.userState.users
        dataSource.areas = core.state.queueState.areas
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
    
}


// MARK: - Tableview delegate

extension QueueManagementViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

}


// MARK: - Subscriber

extension QueueManagementViewController: Subscriber {

    func update(with state: AppState) {

    }
    
}
