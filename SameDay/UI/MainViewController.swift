//
//  ViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 5/21/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var core = App.sharedCore
    fileprivate(set) var currentViewController: UIViewController?
    fileprivate var homeViewController = HomeTabBarController.initializeFromStoryboard()
    fileprivate var loginViewController = LoginViewController.initializeFromStoryboard()

    override func viewDidLoad() {
        super.viewDidLoad()
        core.add(subscriber: self)
        core.fire(command: LoadAreas())
        core.fire(command: LoadUser())
    }

}


private extension MainViewController {

    func showHomeViewController() {
        _ = showViewController(homeViewController)
    }

    func showLoginViewController() {
        _ = showViewController(loginViewController)
    }

    func showViewController(_ viewController: UIViewController) -> Bool {
        guard currentViewController != viewController else { return false }

        if let controller = currentViewController {
            controller.removeFromParent()
            controller.view.removeFromSuperview()
        }
        addChild(viewController)
        view.addSubview(viewController.view)

        currentViewController = viewController

        return true
    }
    
}

extension MainViewController: Subscriber {

    func update(with state: AppState) {
        if state.loginState.isLoggedIn {
            showHomeViewController()
        } else {
            showLoginViewController()
        }
    }

}

