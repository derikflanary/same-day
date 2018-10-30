//
//  LoadUser.swift
//  SameDay
//
//  Created by Derik Flanary on 6/19/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadUser: SameDayAPICommand {

    var userId: String

    init(userId: String) {
        self.userId = userId
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.User.getUser(userId: userId)
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            if let json = response.result.value as? JSONObject {
                do {
                    let employee: Employee = try json.value(for: Keys.employee)
                    core.fire(event: LoadedUser(user: employee))
                    if employee.type == .manager {
                        core.fire(command: LoadManagerEmployees(employee: employee))
                    }
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
