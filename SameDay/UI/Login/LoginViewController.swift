//
//  LoginViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, StoryboardInitializable {

    static var storyboardName = "Login"
    static var viewControllerIdentifier = "LoginViewController"

    var core = App.sharedCore
    var tapGestureRecognizer = UITapGestureRecognizer()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func submitButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        core.fire(command: Authenticate(username: username, password: password))
    }
    
}
