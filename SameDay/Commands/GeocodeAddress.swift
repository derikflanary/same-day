//
//  GeocodeAddress.swift
//  SameDay
//
//  Created by Derik Flanary on 6/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal
import CoreLocation

struct GeocodeAddress: Command {

    private var networkAccess: AppointmentNetworkAccess = AppointmentNetworkAPIAccess.sharedInstance
    var appointment: Appointment
    var area: Area?

    init(appointment: Appointment, area: Area?) {
        self.appointment = appointment
        self.area = area
    }

    func execute(state: AppState, core: Core<AppState>) {
        let address = appointment.addressString
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first {
                var updatedAppointment = self.appointment
                updatedAppointment.coordinates = placemark.location?.coordinate
                if let area = self.area {
                    var updatedArea = area
                    updatedArea.unassignedAppointments.replace(item: updatedAppointment)
                    core.fire(event: Updated(item: updatedArea))
                } else {
                    core.fire(event: Updated(item: updatedAppointment))
                }
            } else if let error = error {
                print(error)
            }
        }
    }
}
