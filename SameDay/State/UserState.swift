//
//  UserState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct UserState: State {

    var users = [User(name: "Gilg Gwilliams"), User(name: "Mary Jane")]
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Added<User>:
            users.append(event.item)
        default:
            break
        }
    }

}
