//
//  LoadManagerEmployees.swift
//  SameDay
//
//  Created by Derik Flanary on 7/11/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadManagerEmployees: Command {

    private var networkAccess: UserNetworkAccess = UserNetworkAPIAccess.sharedInstance
    let employee: Employee


    init(employee: Employee) {
        self.employee = employee
    }

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getEmployeesUnderManager(id: employee.id) { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    let employees: [Employee] = try json.value(for: "employee.employees")
                    var updatedEmployee = self.employee
                    updatedEmployee.employees = employees
                    core.fire(event: Updated(item: updatedEmployee))
                } catch {
                    print(error)
                }
            }
        }
    }

}
