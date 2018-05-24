//
//  Area.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct Area {
    let name: String
    var users: [User]
}

extension Area: Equatable {
    static func == (lhs: Area, rhs: Area) -> Bool {
        return lhs.name == rhs.name
    }
}
