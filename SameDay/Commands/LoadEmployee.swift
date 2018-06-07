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


struct LoadEmployee: Command {

    private var networkAccess: UserNetworkAccess = UserNetworkAPIAccess.sharedInstance

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getUser(id: 94) { (response) in
            if let json = response?.result.value {
                print(json)
            }
        }
    }
}


