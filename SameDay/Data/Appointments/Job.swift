//
//  Job.swift
//  SameDay
//
//  Created by Derik Flanary on 6/5/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import CoreLocation

struct Job: Coordinatable {

    var id: TimeInterval
    var date: Date
    var duration: Int
    var title: String
    var coordinate: CLLocationCoordinate2D

    var startTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }

    var endTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let time = Calendar.current.date(byAdding: .hour, value: duration, to: date)
        return formatter.string(from: time!)
    }

}

extension Job: Equatable {

    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }

}
