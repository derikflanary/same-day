//
//  LoadUnassignedAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal


struct LoadAllUnassignedAppointments: SameDayAPICommand {
    
    let areas: [Area]
    
    init(for areas: [Area]) {
        self.areas = areas
    }
    
    func execute(network: API, state: AppState, core: Core<AppState>) {
        for area in areas {
            core.fire(command: LoadUnassignedAppointmentsForArea(area: area, startDate: nil))
        }
    }
    
}

struct LoadUnassignedAppointmentsForArea: SameDayAPICommand {

    let area: Area
    var startDate: Date?

    init(area: Area, startDate: Date?) {
        self.area = area
        self.startDate = startDate
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.Appointment.getAppointmentsForArea(areaId: area.id)
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            if let json = response.value {
                do {
                    let appointments: [Appointment] = try json.value(for: Keys.items)
                    if !appointments.isEmpty {
                        print(json)
                    }
                    var updatedArea = self.area
                    updatedArea.isLoaded = true
                    updatedArea.unassignedAppointments = appointments
                    core.fire(event: Updated(item: updatedArea))
                    for appointment in appointments {
                        core.fire(command: GeocodeAddress(appointment: appointment, area: updatedArea))
                    }
                } catch {
                    print(error)
                }
            } else {
                var updatedArea = self.area
                updatedArea.isLoaded = true
                core.fire(event: Updated(item: updatedArea))
            }
        }
    }

}

