//
//  Area.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import CoreLocation

struct Area {
    var name: String
    var users: [User]
    var coordinate: CLLocationCoordinate2D
}

extension Area: Equatable {
    static func == (lhs: Area, rhs: Area) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
