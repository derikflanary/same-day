//
//  LoadEmployee.swift
//  SameDay
//
//  Created by Derik Flanary on 6/6/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire
import Marshal


struct LoadEmployee: SameDayAPICommand {

    let userId: String

    init(userId: String) {
        self.userId = userId
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.User.getUser(userId: userId)
        network.request(urlRequest, responseAs: Employee.self, with: core)
    }

}


