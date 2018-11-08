//
//  LoadEmployeeForArea.swift
//  SameDay
//
//  Created by Derik Flanary on 11/8/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire

struct LoadEmployeesForArea: SameDayAPICommand {

    var areaId: String

    init(areaId: String) {
        self.areaId = areaId
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.Area.getEmployeesForArea(areaId: areaId)
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            if let json = response.value {
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

