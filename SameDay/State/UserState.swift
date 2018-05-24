//
//  UserState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct UserState: State {

    var areas = [Area(name: "Provo", users: [User(name: "Gilg Gwilliams")]),
                 Area(name: "Lehi", users: [User(name: "Mary Jane")])]

    mutating func react(to event: Event) {
        switch event {
        case let event as Loaded<Area>:
            areas = event.items
        case let event as Added<Area>:
            areas.append(event.item)
        case let event as Updated<Area>:
            areas.replace(item: event.item)
        default:
            break
        }
    }

}

