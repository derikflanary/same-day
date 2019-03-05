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
    
    let userId: Int
    
    init(for userId: Int) {
        self.userId = userId
    }
    
    func execute(network: API, state: AppState, core: Core<AppState>) {
        let request = Router.Appointment.getAllOpenAppointment(userId: userId)
        network.sessionManager.request(request).responseMarshaled { response in
            if let json = response.value {
                do {
                    let appointments: [Appointment] = try json.value(for: Keys.items)
                    if !appointments.isEmpty {
                        print(json)
                    }
                    core.fire(event: LoadedUnassignedAppointment(appointments: appointments))
                    for appointment in appointments {
                        core.fire(command: GeocodeAddress(appointment: appointment, area: nil))
                    }
                } catch {
                    print(error)
                }
            } else {
                core.fire(event: LoadedUnassignedAppointment(appointments: []))
            }
        }
    }
    
}

struct LoadedUnassignedAppointment: Event {
    let appointments: [Appointment]
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

