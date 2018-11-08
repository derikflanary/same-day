//
//  FetchCredentialsFromKeychain.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct FetchCredentialsFromKeychain: Command {

    func execute(state: AppState, core: Core<AppState>) {
        if let account = KeychainWrapper.standard.string(forKey: Keys.account) {
            if let password = KeychainWrapper.standard.string(forKey: account) {
                core.fire(command: Authenticate(username: account, password: password))
                return
            }
        }
        core.fire(event: AuthenticationFailed(message: "Authentication from Keychain failed"))
    }

}
