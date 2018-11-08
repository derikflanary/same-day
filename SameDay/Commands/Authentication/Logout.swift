//
//  Logout.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct Logout: Command {

    func execute(state: AppState, core: Core<AppState>) {
        OAuth2Token.delete()
        core.fire(event: LoggedOut())
    }

}
