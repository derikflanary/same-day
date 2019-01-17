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

enum AppointmentUpdateType {
    case accept
    case deny
    case complete
    
    var result: AppointmentResult {
        switch self {
        case .accept, .deny:
            return .open
        case .complete:
            return .completed
        }
    }
    
    var successMessage: String {
        switch self {
        case .accept:
            return "You have successfully accepted the appointment"
        case .deny:
            return "You have successfully denied the appointment"
        case .complete:
            return "The appointment as been marked as completed"
        }
    }
}

struct UpdateAppointment: SameDayAPICommand {

    let userId: Int?
    let appointment: Appointment
    let updateType: AppointmentUpdateType
    var completion: ((Bool, String?) -> Void)?

    init(for userId: Int?, appointment: Appointment, updateType: AppointmentUpdateType, completion: ((Bool, String?) -> Void)?) {
        self.userId = userId
        self.appointment = appointment
        self.updateType = updateType
        self.completion = completion
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.Appointment.postAppointmentUpdate(employeeId: userId, appointmentId: appointment.id, updateType: updateType.result.rawValue)
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            if let json = response.value {
                do {
                    if let error: String = try json.value(for: Keys.error) {
                        print(error)
                        self.completion?(false, "Failed to update the appointment")
                    } else {
                        var updatedAppointment = self.appointment
                        updatedAppointment.result = self.updateType.result
                        updatedAppointment.employeeId = self.userId
                        if updatedAppointment.employeeId == nil {
                            core.fire(event: Deleted(item: updatedAppointment))
                        } else {
                            core.fire(event: Updated(item: updatedAppointment))                            
                        }
                        self.completion?(true, self.updateType.successMessage)
                    }
                } catch {
                    self.completion?(false, "Failed to update the appointment")
                }
            }
        }
    }

}
