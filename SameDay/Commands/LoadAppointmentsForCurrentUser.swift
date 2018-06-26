//
//  LoadAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/20/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadAppointmentsForCurrentUser: Command {

    private var networkAccess: AppointmentNetworkAccess = AppointmentNetworkAPIAccess.sharedInstance

    func execute(state: AppState, core: Core<AppState>) {
        guard let currentUserId = state.userState.currentUser?.id else { return }
        networkAccess.getAppointments(for: currentUserId) { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    let appointments: [Appointment] = try json.value(for: "employee.open_appointments")
                    core.fire(event: Loaded(items: appointments))
                    for appointment in appointments {
                        core.fire(command: GeocodeAddress(appointment: appointment))
                    }
                } catch {
                    print(error)
                }
            }
        }
    }

}

struct LoadUnassignedAppointments: Command {

    private var networkAccess: AppointmentNetworkAccess = AppointmentNetworkAPIAccess.sharedInstance
    let area: Area

    init(for area: Area) {
        self.area = area
    }

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getUnassignedAppointments(for: area.id) { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    let appointments: [Appointment] = try json.value(for: Keys.appointments)
                    var updatedArea = self.area
                    updatedArea.unassignedAppointments = appointments
                    core.fire(event: LoadedUnassignedAppointments(appointments: appointments, area: self.area))
                } catch {
                    print(error)
                }
            }
        }
    }

}

struct LoadedUnassignedAppointments: Event {
    let appointments: [Appointment]
    var area: Area
}
