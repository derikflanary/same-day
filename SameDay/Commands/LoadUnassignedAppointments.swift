//
//  LoadUnassignedAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadUnassignedAppointmentsForArea: Command {

    private var networkAccess: AppointmentNetworkAccess = AppointmentNetworkAPIAccess.sharedInstance
    let area: Area
    var startDate: Date?


    init(area: Area, startDate: Date?) {
        self.area = area
        self.startDate = startDate
    }

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getUnassignedAppointments(for: area.id) { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    let appointments: [Appointment] = try json.value(for: Keys.appointments)
                    var updatedArea = self.area
                    updatedArea.unassignedAppointments = appointments
                    core.fire(event: Updated(item: updatedArea))
                } catch {
                    print(error)
                }
            }
        }
    }

}

