//
//  LoadAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/20/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadAppointments: Command {

    private var networkAccess: AppointmentNetworkAccess = AppointmentNetworkAPIAccess.sharedInstance

    func execute(state: AppState, core: Core<AppState>) {
        guard let currentUserId = state.userState.currentUser?.id else { return }
        networkAccess.getAppointments(for: currentUserId) { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    let appointments: [Appointment] = try json.value(for: "employee.open_appointments")
                    core.fire(event: Loaded(items: appointments))
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
