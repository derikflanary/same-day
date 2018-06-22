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
        CLGeocoder().geocodeAddressString(appointment.invoice.account.addressString) { placemarks, error in
            if let placemark = placemarks?.first {
                var updatedAppointment = self.appointment
                updatedAppointment.invoice.account.coordinates = placemark.location?.coordinate
                core.fire(event: Updated(item: updatedAppointment))
            } else if let error = error {
                print(error)
            }
        }
//        networkAccess.geocode(address: appointment.invoice.account.addressString) { response in
//            if let json = response?.result.value as? JSONObject {
//                do {
//                    let longitude: Double = try json.value(for: "results.geometry.location.lng")
//                    let latitude: Double = try json.value(for: "results.geometry.location.lat")
//                    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                    var updatedAppointment = self.appointment
//                    updatedAppointment.invoice.account.coordinates = coordinates
//                    core.fire(event: Updated(item: updatedAppointment))
//                } catch {
//                    print(error)
//                }
//            }
//        }
    }
}
