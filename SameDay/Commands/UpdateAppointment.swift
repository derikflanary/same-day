//
//  UpdateAppointment.swift
//  SameDay
//
//  Created by Derik Flanary on 11/28/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

enum AppointmentResult: String {
    case cancelled = "Cancelled"
    case completed = "Completed"
    case enRoute = "En Route"
    case open = "Open"
    case rescheduled = "Rescheduled"
    case visited = "Visited"
}

struct UpdateAppointment: SameDayAPICommand {

    let userId: Int
    let appointment: Appointment
    let updateType: AppointmentResult

    init(for userId: Int, appointment: Appointment, updateType: AppointmentResult) {
        self.userId = userId
        self.appointment = appointment
        self.updateType = updateType
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.Appointment.postAppointmentUpdate(employeeId: userId, appointmentId: appointment.id, updateType: updateType.rawValue)
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            if let json = response.value {
                var updatedAppointment = self.appointment
                updatedAppointment.result = self.updateType
                core.fire(event: Updated(item: updatedAppointment))
                print(json)
            }
        }
    }

}
