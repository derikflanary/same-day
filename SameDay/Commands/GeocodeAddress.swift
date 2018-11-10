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

    init(appointment: Appointment) {
        self.appointment = appointment
    }

    func execute(state: AppState, core: Core<AppState>) {
        guard let address = appointment.invoice?.account.addressString else { return }
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first {
                var updatedAppointment = self.appointment
                updatedAppointment.invoice?.account.coordinates = placemark.location?.coordinate
                core.fire(event: Updated(item: updatedAppointment))
            } else if let error = error {
                print(error)
            }
        }
    }
}
