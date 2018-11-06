//
//  HomeTabBarController.swift
//  SameDay
//
//  Created by Derik Flanary on 5/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController, StoryboardInitializable {

    static var storyboardName = "Home"
    static var viewControllerIdentifier = "HomeTabBarController"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let biometryEnabled = BiometricAuthenticator.sharedInstance.biometryIsEnabled,
            let biometryType = BiometricAuthenticator.sharedInstance.biometryType,
            let biometryRequested = BiometricAuthenticator.sharedInstance.biometryUsageRequested,
            !biometryEnabled,
            !biometryRequested else { return }
        let alert = UIAlertController(title: biometryType.biometryTypeString, message: "Would you like to enable for future authenticaton?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default) { (_) in
            BiometricAuthenticator.sharedInstance.biometryIsEnabled = true
        }
        let cancel = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        show(alert, sender: self)
        BiometricAuthenticator.sharedInstance.biometryUsageRequested = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
