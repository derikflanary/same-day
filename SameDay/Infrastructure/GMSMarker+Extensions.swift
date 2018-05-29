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