//
//  Alamofire+Reactor.swift
//  align
//
//  Created by Tim on 1/12/18.
//  Copyright © 2018 OC Tanner. All rights reserved.
//

import Alamofire
import Foundation

struct Loaded<T>: Event {
    var object: T
}

struct Requested: Event {
    var request: URLRequest
}

struct Responded: Event {
    var url: URL?
    var status: Int?
}

struct Refreshed<T>: Event {
    var object: T
}

struct Errored: Event {
    var error: Error
}

protocol NetworkCommand: Command {
    func network<T>(from state: T) -> API where T == StateType
    func execute<T>(network: API, state: T, core: Core<T>) where T == StateType
}

extension NetworkCommand {
    func execute(state: StateType, core: Core<StateType>) {
        execute(network: network(from: state), state: state, core: core)
    }
}
