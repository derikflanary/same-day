//
//  GMSMarker+Extensions.swift
//  SameDay
//
//  Created by Derik Flanary on 5/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMarker {

    func designed(with title: String? = nil) {
        self.title = title
        icon = #imageLiteral(resourceName: "map-pin-large")
        opacity = 0.9
    }

    func designedForDragging() {
        icon = #imageLiteral(resourceName: "map-pin-move")
        opacity = 0.5
    }

}


extension Array where Element == FakeArea {

    func area(for marker: GMSMarker) -> FakeArea? {
        return self.filter { $0.coordinate.latitude == marker.position.latitude && $0.coordinate.longitude == marker.position.longitude }.first
    }

}

extension Array where Element == Job {

    func job(for marker: GMSMarker) -> Job? {
        return self.filter { $0.coordinate.latitude == marker.position.latitude && $0.coordinate.longitude == marker.position.longitude }.first
    }

}
extension Array where Element == GMSMarker {

    func marker(for coordinates: CLLocationCoordinate2D) -> GMSMarker? {
        return self.filter { $0.position.latitude == coordinates.latitude && $0.position.longitude == coordinates.longitude }.first
    }

}
