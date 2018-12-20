//
//  UserState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct UserState: State {

    var currentUserId: Int? {
        do {
            return try fetchCurrentUserId()
        } catch {
            return nil
        }
    }
    var currentUser: Employee?
    var users = [User(name: "Gilg Gwilliams"), User(name: "Mary Jane")]
    var areas = [Area]()
    var currentArea: Area? {
        if let defaultAreaId = currentUser?.defaultAreaId {
            return areas.filter { $0.id == defaultAreaId }.first
        } else {
            return areas.first
        }
    }

    public func fetchCurrentUserId() throws -> Int? {
        guard let token = try OAuth2Token() else { return nil }
        return token.userId
    }

    
    mutating func react(to event: Event) {
        switch event {
        case let event as LoadedUser:
            currentUser = event.user
        case let event as Updated<Employee>:
            currentUser = event.item
        case let event as Added<User>:
            users.append(event.item)
        case let event as Loaded<[Area]>:
            areas = event.object
        default:
            break
        }
    }

}
