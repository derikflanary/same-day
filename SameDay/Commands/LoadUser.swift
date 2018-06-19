//
//  LoadUser.swift
//  SameDay
//
//  Created by Derik Flanary on 6/19/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadUser: Command {

    private var networkAccess: UserNetworkAccess = UserNetworkAPIAccess.sharedInstance

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getUser(id: 94) { (response) in
            if let json = response?.result.value as? JSONObject {
                do {
                    let employee: Employee = try json.value(for: Keys.employee)
                    core.fire(event: LoadedUser(user: employee))
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct LoadedUser: Event {
    let user: Employee
}
