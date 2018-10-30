//
//  NetworkConfig.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

struct NetworkConfig {

    static let shared = NetworkConfig()

    // MARK: - Internal properties

    let sameDay: API

    init() {
        let environment = Environment.prod
        self.sameDay = API(environment: SameDayAPIEnvironment(environment: environment))
    }

}

enum Environment: String/*, CaseIterable*/ {
    case prod

    var apiURLBase: String {
        return "https://samedayapi.azurewebsites.net"
    }

}
