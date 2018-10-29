//
//  PersonalScheduleState.swift
//  SameDay
//
//  Created by Derik Flanary on 6/1/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import CoreLocation

struct PersonalScheduleState: State {

    var selectedDate = Date()
    var appointments = [Appointment]()

    var appointmentsOfSelectedDate: [Appointment] {
        let filteredAppointments = appointments.filter { Calendar.current.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame }
        return filteredAppointments.sorted(by:  { $0.date < $1.date })
    }

    var datesWithAppointments: [Date] {
        return appointments.map { $0.date }
    }

    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Date>:
            selectedDate = event.item
        case let event as Loaded<[Appointment]>:
            appointments = event.object
        case let event as Updated<Appointment>:
            appointments.replace(item: event.item)
        default:
            break
        }
    }

}
