//
//  AuthenticateToken.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct AuthenticateToken: Command {

    func execute(state: AppState, core: Core<AppState>) {
        if let _ = state.accessToken {
            core.fire(event: LoggedIn())
            if let userId = state.userState.currentUserId {
                core.fire(command: LoadUser(userId: userId))
                core.fire(command: LoadAppointments(for: userId))
            }
        } else {
            core.fire(event: LoggedOut())
        }
    }

}
