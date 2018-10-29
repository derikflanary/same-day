//
//  LoadAreas.swift
//  SameDay
//
//  Created by Derik Flanary on 6/26/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadAreas: Command {

    private var networkAccess: UserNetworkAccess = UserNetworkAPIAccess.sharedInstance

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getAreas { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    var areas: [Area] = try json.value(for: Keys.areas)
                    areas = areas.filter { $0.isActive }
                    core.fire(event: Loaded(object: areas))
                } catch {
                    print(error)
                }
            }
        }
    }

}
