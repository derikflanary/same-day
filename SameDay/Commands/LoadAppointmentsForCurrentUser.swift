//
//  LoadAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/20/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadAppointmentsForCurrentUser: SameDayAPICommand {

    func execute(network: API, state: AppState, core: Core<AppState>) {
        guard let currentUserId = state.userState.currentUser?.id else { return }
        let urlRequest = Router.Appointment.getAppointments(userId: currentUserId)
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
