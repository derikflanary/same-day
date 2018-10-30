//
//  GenericEvents.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct Created<T>: Event {
    let item: T
}

struct Selected<T>: Event {
    var item: T
}

struct Deselected<T>: Event { }

struct Updated<T>: Event {
    var item: T
}

struct Added<T>: Event {
    var item: T
}

struct Deleted<T>: Event {
    var item: T
}

struct Reset<T>: Event {
    var customReset: ((T) -> T)?
}

struct ErrorDisplayed: Event { }

struct AuthenticationFailed: Event {
    let message: String
}

struct AuthenticationSucceeded: Event {
    let userId: String
}

struct LoggedIn: Event { }

struct LoggedOut: Event { }

