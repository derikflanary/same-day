//
//  QueueState.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import GoogleMaps

struct QueueState: State {

    var markers = [GMSMarker]()
    var areas = [Area]()
    var fakeAreas = [FakeArea]()
    

    mutating func react(to event: Event) {
        switch event {
        case let event as Loaded<[Area]>:
            areas = event.object
        case let event as Updated<Area>:
            areas.replace(item: event.item)
        default:
            break
        }
    }

}
