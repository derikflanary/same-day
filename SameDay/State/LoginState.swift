//
//  LoginState.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct LoginState: State {

    var errorMessage: String?
    var authenticationSucceeded = false

    mutating func react(to event: Event) {
        switch event {
        case let event as AuthenticationFailed:
            errorMessage = event.message
        case _ as AuthenticationSucceeded:
            authenticationSucceeded = true
        default:
            break
        }
    }

}
