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
    var isLoggedIn = false

    mutating func react(to event: Event) {
        errorMessage = nil
        switch event {
        case _ as LoggedIn:
            isLoggedIn = true
        case _ as LoggedOut:
            isLoggedIn = false
        case let event as AuthenticationFailed:
            errorMessage = event.message
        case _ as AuthenticationSucceeded:
            isLoggedIn = true
        case _ as ErrorDisplayed:
            errorMessage = nil
        default:
            break
        }
    }

}
