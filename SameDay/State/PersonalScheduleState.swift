//
//  PersonalScheduleState.swift
//  SameDay
//
//  Created by Derik Flanary on 6/1/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import CoreLocation

struct PersonalScheduleState: State {

    let jobs = [Job(id: Date().timeIntervalSince1970, date: Calendar.current.date(byAdding: .hour, value: 25, to: Date())!, duration: 3, title: "Installation", coordinate: CLLocationCoordinate2D(latitude: 40.2338, longitude: -111.6585)), Job(id: Date().timeIntervalSince1970, date: Date(), duration: 2, title: "Repairs", coordinate: CLLocationCoordinate2D(latitude: 40.23646472542008, longitude: -111.64462912846682)), Job(id: Date().timeIntervalSince1970, date: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!, duration: 3, title: "Double Installation", coordinate: CLLocationCoordinate2D(latitude: 40.2338, longitude: -111.659)),]
    
    var jobsOfSelectedDate: [Job] {
        let filteredJobs = jobs.filter { Calendar.current.compare($0.date, to: selectedDate, toGranularity: .day) == .orderedSame }
        return filteredJobs.sorted(by:  { $0.date < $1.date })
    }

    var datesWithJobs: [Date] {
        return jobs.map { $0.date }
    }
    
    var selectedDate = Date()
    var appointments = [Appointment]()

    mutating func react(to event: Event) {
        switch event {
        case let event as Selected<Date>:
            selectedDate = event.item
        case let event as Loaded<Appointment>:
            appointments = event.items
        default:
            break
        }
    }

}
