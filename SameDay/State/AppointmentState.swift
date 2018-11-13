//
//  AppointmentState.swift
//  SameDay
//
//  Created by Derik Flanary on 11/12/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

enum AppointmentSourceType {
    case potential
    case personalSchedule
}

struct AppointmentState: State {

    var selectedAppointment: Appointment?
    var appointmentSourceType: AppointmentSourceType = .potential

    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Appointment>:
            selectedAppointment = event.item
        case let event as Selected<AppointmentSourceType>:
            appointmentSourceType = event.item
        default:
            break
        }
    }

}
