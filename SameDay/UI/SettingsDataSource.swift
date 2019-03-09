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
    
    var shouldUseBiometricAuth: Bool {
        guard let biometryEnabled = BiometricAuthenticator.sharedInstance.biometryIsEnabled else { return false }
        return biometryEnabled
    }
    
    var sections: [Sections] {
        return shouldUseBiometricAuth ? [.biometrics, .logout] : [.logout]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
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

