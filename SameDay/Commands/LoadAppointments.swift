//
//  LoadAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/20/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadAppointments: SameDayAPICommand {

    let userId: Int

    init(for userId: Int) {
        self.userId = userId
    }

    func execute(network: API, state: AppState, core: Core<AppState>) {
        let urlRequest = Router.Appointment.getAllAppointments(userId: userId)
        network.sessionManager.request(urlRequest).responseMarshaled { response in
            if let json = response.value {
                do {
                    let appointments: [Appointment] = try json.value(for: "employee.open_appointments")
                    core.fire(event: Loaded(object: appointments))
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
