//
//  LoginViewController.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit
import Marshal

class LoginViewController: UIViewController, StoryboardInitializable {

    static var storyboardName = "Login"
    static var viewControllerIdentifier = "LoginViewController"

    var core = App.sharedCore
    var tapGestureRecognizer = UITapGestureRecognizer()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: RoundedButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        do {
            let a: MarshaledObject = try Keychain().valueForKey("cby016@gmail.com")
            print(a)
        } catch {
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        animateInViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @IBAction func submitButtonTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        core.fire(command: Authenticate(username: username, password: password))
        submitButton.isLoading = !submitButton.isLoading
    }
    
    @IBAction func usernameDidChange() {
        updateSubmitButton()
    }

    @IBAction func passwordDidChange() {
        updateSubmitButton()
    }
    
}

private extension LoginViewController {

    func animateInViews() {
        stackView.transform = CGAffineTransform(translationX: 0, y: 200)
        submitButton.transform = CGAffineTransform(translationX: 0, y: 200)
        let animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.8) {
            self.logoCenterYConstraint.isActive = false
            self.logoTopConstraint.isActive = true
            self.view.layoutIfNeeded()
            self.stackView.transform = .identity
            self.stackView.alpha = 1.0
            self.submitButton.isEnabled = false
            self.submitButton.transform = .identity
        }
        animator.startAnimation()
    }

    func updateSubmitButton() {
        if let username = usernameTextField.text, username != "", let password = passwordTextField.text, password != "" {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
}


// MARK: - Subscriber

extension LoginViewController: Subscriber {

    func update(with state: AppState) {
        if state.loginState.isLoggedIn {
            submitButton.isLoading = false
        }
        if let message = state.loginState.errorMessage {
            submitButton.isLoading = false
            submitButton.shake()
            showAlert(title: "Authentication failed", message: message, image: nil, completion: nil)
        }
    }

}

