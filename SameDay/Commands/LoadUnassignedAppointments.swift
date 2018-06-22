//
//  LoadUnassignedAppointments.swift
//  SameDay
//
//  Created by Derik Flanary on 6/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct LoadUnassignedAppointmentsForArea: Command {

    private var networkAccess: AppointmentNetworkAccess = AppointmentNetworkAPIAccess.sharedInstance
    let areaId: Int
    var startDate: Date?


    init(areaId: Int, startDate: Date?) {
        self.areaId = areaId
        self.startDate = startDate
    }

    func execute(state: AppState, core: Core<AppState>) {
        networkAccess.getUnassignedAppointments(for: areaId) { response in
            if let json = response?.result.value as? JSONObject {
                do {
                    let appointments: [Appointment] = try json.value(for: Keys.appointments)
                    core.fire(event: Loaded(items: appointments))
                } catch {
                    print(error)
                }
            }
        }
    }

}
