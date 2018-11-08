//
//  SettingsViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 11/7/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var core = App.sharedCore

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var datasource: SettingsDataSource!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = SettingsDataSource.Sections.allCases[indexPath.section]
        switch section {
        case .biometrics:
            break
        case .logout:
            dismiss(animated: true, completion: nil)
            core.fire(command: Logout())
        }
    }
}


// MARK: - Subscriber

extension SettingsViewController: Subscriber {

    func update(with state: AppState) {

    }

}
