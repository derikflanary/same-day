//
//  Appointment.swift
//  SameDay
//
//  Created by Derik Flanary on 6/19/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal
import CoreLocation

struct Appointment: Unmarshaling {

    enum Result: String {
        case open = "Open"
        case rescheduled = "Rescheduled"
    }

    let addedByEmployeeId: Int
    let date: Date
    let areaId: Int
    let areaName: String
    var arrival: Date? = nil
    let dateAdded: Date?
    var departure: Date? = nil
    let duration: Int
    let employeeId: Int?
    let endTime: Int
    var eta: Date? = nil
    let id: Int
    let invoiceId: Int
    let lastModifiedById: Int?
    let modifiedDate: Date?
    let result: Result
    let startTime: Int
    var invoice: Invoice?
    let phone: String
    let street: String
    let streetTwo: String?
    let zip: String
    let city: String
    let firstName: String
    let lastName: String
    let state: String
    var coordinates: CLLocationCoordinate2D?

    var displayStartTime: String? {
        guard let arrival = arrival else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: arrival)
    }

    var displayStartDateAndTime: String? {
        guard let arrival = arrival else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: arrival)
    }

    var displayEndTime: String? {
        guard let arrival = arrival else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: duration.hours.after(arrival))
    }

    var displayEndDateAndTime: String? {
        guard let arrival = arrival else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: duration.hours.after(arrival))
    }

    var displayName: String {
        return "\(firstName) \(lastName)".lowercased().uppercased()
    }

    var addressString: String {
        return "\(street), \(city), \(state) \(zip)".lowercased().uppercased()
    }

    init(object: MarshaledObject) throws {
        addedByEmployeeId = try object.value(for: Keys.addedByEmployeeId)
        var dateString: String = try object.value(for: Keys.date)
        date = dateString.date() ?? Date()
        areaId = try object.value(for: Keys.areaId)
        areaName = try object.value(for: Keys.areaName)
        let arrivalString: String? = try object.value(for: Keys.arrival)
        if let arrivalSting = arrivalString {
            arrival = arrivalSting.date()
        }
        dateString = try object.value(for: Keys.dateAdded)
        dateAdded = dateString.date()
        let departureString: String? = try object.value(for: Keys.departure)
        if let departureString = departureString {
            departure = departureString.date()
        }
        duration = try object.value(for: Keys.duration)
        employeeId = try object.value(for: Keys.employeeID)
        endTime = try object.value(for: Keys.endTime)
        let etaString: String? = try object.value(for: Keys.eta)
        if let etaString = etaString {
            eta = etaString.date()
        }
        id = try object.value(for: Keys.id)
        invoiceId = try object.value(for: Keys.invoiceId)
        lastModifiedById = try object.value(for: Keys.lastModifiedById)
        dateString = try object.value(for: Keys.modifiedDate)
        modifiedDate = dateString.date()
        result = try object.value(for: Keys.result)
        startTime = try object.value(for: Keys.startTime)
        invoice = try object.value(for: Keys.invoice)
        phone = try object.value(for: Keys.phone)
        street = try object.value(for: Keys.street)
        streetTwo = try object.value(for: Keys.street2)
        city = try object.value(for: Keys.city)
        zip = try object.value(for: Keys.zip)
        state = try object.value(for: Keys.state)
        firstName = try object.value(for: Keys.firstName)
        lastName = try object.value(for: Keys.lastName)
    }
}

struct Invoice: Unmarshaling {

    let id: Int
    let employeeId: Int
    let accountId: Int
    let leadEmployeeId: Int?
    let claimId: String?
    let saleDate: Date
    let installDate: Date
    let invoiceType: String
    let status: String
    let satelliteProvider: String
    let numberTvs: Int
    let promotionId: Int?
    let kitId: Int?
    let receivers: Int
    let programmingQuote: String?
    let processed: Bool
    let submitted: Bool
    let paid: Bool

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        employeeId = try object.value(for: Keys.employeeId)
        accountId = try object.value(for: Keys.accountId)
        leadEmployeeId = try object.value(for: Keys.leadEmployeeId)
        claimId = try object.value(for: Keys.claimId)
        saleDate = try object.value(for: Keys.saleDate)
        installDate = try object.value(for: Keys.installDate)
        invoiceType = try object.value(for: Keys.invoiceType)
        status = try object.value(for: Keys.status)
        satelliteProvider = try object.value(for: Keys.satelliteProvider)
        numberTvs = try object.value(for: Keys.numberTvs)
        promotionId = try object.value(for: Keys.promotionId)
        kitId = try object.value(for: Keys.kitId)
        receivers = try object.value(for: Keys.receivers)
        programmingQuote = try object.value(for: Keys.programmingQuote)
        processed = try object.value(for: Keys.processed)
        submitted = try object.value(for: Keys.submitted)
        paid = try object.value(for: Keys.paid)
    }

}


extension Appointment: Equatable {

    static func == (lhs: Appointment, rhs: Appointment) -> Bool {
        return lhs.id == rhs.id
    }

}
