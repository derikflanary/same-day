//
//  AppState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/21/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

enum App {

    static var sharedCore = Core(state: AppState(), middlewares: [])

}

struct AppState: State {

    var userState = UserState()
    var queueState = QueueState()
    var personalScheduleState = PersonalScheduleState()
    var loginState = LoginState()

    var accessToken: String? {
        do {
            return try fetchAccessToken()
        } catch {
            return nil
        }
    }

    private func fetchAccessToken() throws -> String? {
        guard let token = try OAuth2Token() else { return nil }
        if Date().compare(token.expiresAt) == .orderedAscending {
            return token.accessToken
        } else {
            return nil
        }
    }

    mutating func react(to event: Event) {
        loginState.react(to: event)
        userState.react(to: event)
        queueState.react(to: event)
        personalScheduleState.react(to: event)
    }

}
