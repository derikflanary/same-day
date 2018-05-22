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

    override func viewDidLoad() {
        super.viewDidLoad()
        core.add(subscriber: self)
    }

}


private extension MainViewController {

    func showHomeViewController() {
        _ = showViewController(homeViewController)
    }

    func showViewController(_ viewController: UIViewController) -> Bool {
        guard currentViewController != viewController else { return false }

        if let controller = currentViewController {
            controller.removeFromParentViewController()
            controller.view.removeFromSuperview()
        }
        addChildViewController(viewController)
        view.addSubview(viewController.view)

        currentViewController = viewController

        return true
    }
    
}

extension MainViewController: Subscriber {

    func update(with state: AppState) {
        showHomeViewController()
    }

}

