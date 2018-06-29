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
    var areas = [FakeArea]()
    var realAreas = [Area]()
    

    mutating func react(to event: Event) {
        switch event {
        case let event as Loaded<FakeArea>:
            areas = event.items
        case let event as Added<FakeArea>:
            areas.append(event.item)
        case let event as Updated<FakeArea>:
            areas.replace(item: event.item)
        case let event as Deleted<FakeArea>:
            areas.remove(item: event.item)
        case let event as Loaded<Area>:
            realAreas = event.items
        case let event as Updated<Area>:
            realAreas.replace(item: event.item)
        default:
            break
        }
    }

}
