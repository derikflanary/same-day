//
//  OnSuccessfulLogin.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct OnSuccessfulLogin: Command {

    let currentUserId: String

    init(for currentUserId: String) {
        self.currentUserId = currentUserId
    }

    func execute(state: AppState, core: Core<AppState>) {
        core.fire(command: LoadUser(userId: currentUserId))
        core.fire(command: LoadAppointments(for: currentUserId))
    }

}
