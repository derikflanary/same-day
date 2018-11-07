//
//  SettingsDataSource.swift
//  SameDay
//
//  Created by Derik Flanary on 11/7/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {

    enum Sections: CaseIterable {
        case biometrics
        case logout
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Sections.allCases[indexPath.section]
        switch section {
        case .biometrics:
            let cell = tableView.dequeueReusableCell() as BiometricsCell
            cell.configure(with: BiometricAuthenticator.sharedInstance.biometryIsEnabled ?? false)
            return cell
        case .logout:
            let cell = tableView.dequeueReusableCell() as LogOutCell
            return cell
        }
    }

}

