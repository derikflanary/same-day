//
//  AppState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/21/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

enum App {

    static var sharedCore = Core(state: AppState(), middlewares: [])

}

struct AppState: State {

    mutating func react(to event: Event) {

    }

}