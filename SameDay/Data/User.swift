//
//  User.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct User: Unmarshaling {
    let name: String

    init(object: MarshaledObject) throws {
        name = try object.value(for: "name")
    }

    init(name: String) {
        self.name = name
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
}

