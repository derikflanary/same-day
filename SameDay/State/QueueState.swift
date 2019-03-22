//
//  QueueState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import GoogleMaps

struct QueueState: State {

    var markers = [GMSMarker]()
    var areas = [Area]()
    var potentialUnassignedAppointments = [Appointment]()
    var appointmentsLoaded: Bool = false
    
    mutating func react(to event: Event) {
        switch event {
        case let event as Loaded<[Area]>:
            areas = event.object
        case let event as LoadedUnassignedAppointment:
            potentialUnassignedAppointments = event.appointments
            appointmentsLoaded = true
        case let event as Updated<Area>:
            areas.replace(item: event.item)
        case let event as Updated<Appointment>:
            if let index = potentialUnassignedAppointments.index(of: event.item) {
                if event.item.employeeId == nil {
                    potentialUnassignedAppointments[index] = event.item
                } else {
                    potentialUnassignedAppointments.remove(at: index)
                }
            }
        case let event as Deleted<Appointment>:
            guard event.item.result == .open && event.item.employeeId == nil else { break }
            potentialUnassignedAppointments.append(event.item)
        default:
            break
        }
    }

}
