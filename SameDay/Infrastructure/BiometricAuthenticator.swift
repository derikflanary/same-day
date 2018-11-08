//
//  BiometricAuthenticator.swift
//  greatwork
//
//  Created by Ben Patch on 5/16/18.
//  Copyright © 2018 OC Tanner Company, Inc. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import SwiftKeychainWrapper

public enum BiometricAuthError: Error {
    case notAvailable
    case canceled
    case passcodeNotEnabled
    case other(Error)
}


// MARK: - Bio Auth Protocol

/// The delegate for BiometricAuthenticator to handle dependency-related logic.
protocol BiometricAuthenticatorDelegate {
    var shouldUseBiometricAuth: Bool { get }

    func biometricAuthenticationSucceeded()
    func cancelAuthAndLogout()
}


// MARK: - BiometricAuthenticator

/// This class is for controlling biometric Authentication
/// If the user fails enough times, they will be locked out.
/// That lockout applies to their phone too...  😱📱🔒
class BiometricAuthenticator {

    static let sharedInstance = BiometricAuthenticator()

    var biometryIsEnabled: Bool? {
        get { return UserDefaults.standard.value(forKey: Keys.biometryIsEnabled) as? Bool }
        set { UserDefaults.standard.set(newValue, forKey: Keys.biometryIsEnabled) }
    }

    var biometryUsageRequested: Bool? {
        get { return UserDefaults.standard.value(forKey: Keys.biometryUsageRequested) as? Bool }
        set { UserDefaults.standard.set(newValue, forKey: Keys.biometryUsageRequested) }
    }

    // MARK: - Private Variables

    private var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics // Use face/touch Auth if possible and passcode if not.
    private var hasSucceeded = false
    private var isCurrentlyEvaluatingPolicy = false
    private var _biometryTypeError: BiometricAuthError?
    private var _biometryType: LABiometryType?
    private var context = LAContext() {
        didSet {
            hasSucceeded = false
        }
    }
    private var localizedReason: String = "Would you like to use your device's biometrics to sign in in the future?"


    // MARK: - Public Variables

    var delegate: BiometricAuthenticatorDelegate?

    var biometryTypeRequiresSystemPermissions: Bool {
        return biometryType == .faceID
    }

    var biometryType: LABiometryType? {
        if let biometryType = _biometryType {
            return biometryType
        }

        guard context.canEvaluatePolicy(policy, error: nil) else {
            return nil
        }
        _biometryType = context.biometryType
        return _biometryType
    }

    var biometryTypeError: BiometricAuthError? {
        if let error = _biometryTypeError {
            return error
        }
        var error: NSError?
        context.canEvaluatePolicy(policy, error: &error)
        _biometryTypeError = error?.biometricAuthError
        return _biometryTypeError
    }


    // MARK: - Public Methods

    // Prompts user to allow biometric auth on first call.
    func authenticateUser(_ completion: ((Bool, BiometricAuthError?) -> Void)? = nil) {
        var error: NSError?
        guard let delegate = delegate, delegate.shouldUseBiometricAuth, context.canEvaluatePolicy(policy, error: &error) else {
            return
        }
        guard !isCurrentlyEvaluatingPolicy else { return }
        isCurrentlyEvaluatingPolicy = true
        context.evaluatePolicy(policy, localizedReason: localizedReason) { (success, error) in
            self.isCurrentlyEvaluatingPolicy = false
            self.hasSucceeded = success
            if success {
                self.delegate?.biometricAuthenticationSucceeded()
            }
            completion?(success, error?.biometricAuthError)
        }
    }

    /// Use this method to re-require authentication.
    /// For instance when the app goes into the background.
    func resetAuthenticationIfNeeded() {
        if hasSucceeded {
            context = LAContext()
        }
    }

    func fetchUserNameAndPassword() -> (String, String)? {
        guard let account = KeychainWrapper.standard.string(forKey: Keys.account),
              let password = KeychainWrapper.standard.string(forKey: account) else {
                return nil
        }
        return (account, password)
    }

}


// MARK: - LABiometryType extension

extension LABiometryType {

    /// The localized string associated with the biometryType (i.e. "Face ID")
    /// .none returns the string "Passcode"
    var biometryTypeString: String {
        switch self {
        case .faceID:
            return NSLocalizedString("Face ID", comment: "Please use the exact name used by Apple for ‘Face ID’ in your language.")
        case .touchID:
            return NSLocalizedString("Touch ID", comment: "Please use the exact name used by Apple for ‘Touch ID’ in your language.")
        case .none:
            return NSLocalizedString("Passcode", comment: "A backup term for `Touch ID` and `Face ID` if the user has not set either of them up.")
        }
    }

}


import LocalAuthentication

// MARK: NSError Extension

public extension Error {

    public var biometricAuthError: BiometricAuthError {
        if let error = self as? LAError {
            return error.biometricAuthError
        } else {
            return BiometricAuthError.other(self)
        }
    }

}


// MARK: NSError Extension

public extension NSError {

    public var biometricAuthError: BiometricAuthError {
        if let error = self as? LAError {
            return error.biometricAuthError
        } else {
            return BiometricAuthError.other(self as Error)
        }
    }

}


// MARK: LAErrorExtension

public extension LAError {

    public var biometricAuthError: BiometricAuthError {
        switch code {
        case .touchIDNotAvailable:
            // Authentication could not start because Touch ID is not available on the device.
            //  Happens if the user says "Don't Allow" on the use biometric prompt if using `LAPolicy.deviceOwnerAuthenticationWithBiometry`.
            return .notAvailable
        case .userCancel, .appCancel, .systemCancel:
            // This happens when the user taps `cancel`, when they tap on a notification
            //  or when anything else causes another app to enter the foreground.
            return .canceled
        case .passcodeNotSet, .touchIDNotEnrolled:
            return .passcodeNotEnabled
        case .touchIDLockout, .userFallback, .invalidContext, .notInteractive, .authenticationFailed:
            // I don't think .touchIDLockout get called with the policy `LAPolicy.deviceOwnerAuthentication`
            // .userFallback allows for a personalized fallback authentication screen when faceId/TouchId
            //   fails, rather than using the device passcode/password
            // .invalidContext happens if you call `myLAContext.invalidate()`
            return .other(self)
        }
    }

}
