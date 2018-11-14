//
//  Area.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import CoreLocation
import Marshal

protocol Coordinatable {
    var coordinate: CLLocationCoordinate2D { get set }
}


struct Area: Unmarshaling {

    let id: Int
    let name: String
    let isActive: Bool
    var unassignedAppointments = [Appointment]()
    var isLoaded = false

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        name = try object.value(for: Keys.name)
        isActive = try object.value(for: Keys.isActive)
        unassignedAppointments = []
    }
}

extension Area: Equatable {

    static func == (lhs: Area, rhs: Area) -> Bool {
        return lhs.id == rhs.id
    }

}


struct ZipCode: Unmarshaling {

    let id: Int
    let areaId: Int
    let zipCode: String
    let createdAt: Date
    let updatedAt: Date

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        areaId = try object.value(for: Keys.areaId)
        zipCode = try object.value(for: Keys.zipcode)
        createdAt = try object.value(for: Keys.createdAt)
        updatedAt = try object.value(for: Keys.updatedAt)
    }
    
}
