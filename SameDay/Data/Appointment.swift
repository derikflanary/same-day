//
//  Appointment.swift
//  SameDay
//
//  Created by Derik Flanary on 6/19/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct Appointment: Unmarshaling {

    enum Result: String {
        case open = "Open"
    }

    let id: Int
    let invoiceId: Int
    let date: Date
    let startTime: Int
    let endTime: Int
    let duration: Int
    let employeeId: Int
    let arrival: Date
    let departure: Date
    let eta: Date
    let result: Result
    let addedByEmployeeId: Int
    let dateAdded: Date
    let lastModifiedById: Int?
    let modifiedDate: Date?
    let invoice: Invoice

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        invoiceId = try object.value(for: Keys.invoiceId)
        date = try object.value(for: Keys.date)
        startTime = try object.value(for: Keys.startTime)
        endTime = try object.value(for: Keys.endTime)
        duration = try object.value(for: Keys.duration)
        employeeId = try object.value(for: Keys.employeeId)
        arrival = try object.value(for: Keys.arrival)
        departure = try object.value(for: Keys.departure)
        eta = try object.value(for: Keys.eta)
        result = try object.value(for: Keys.result)
        addedByEmployeeId = try object.value(for: Keys.addedByEmployeeId)
        dateAdded = try object.value(for: Keys.dateAdded)
        lastModifiedById = try object.value(for: Keys.lastModifiedById)
        modifiedDate = try object.value(for: Keys.modifiedDate)
        invoice = try object.value(for: Keys.invoice)
    }
}

struct Invoice: Unmarshaling {

    let id: Int
    let employeeId: Int
    let accountId: Int
    let leadEmployeeId: Int
    let claimId: String
    let saleDate: Date
    let installDate: Date
    let invoiceType: String
    let status: String
    let satelliteProvider: String
    let numberTvs: Int
    let promotionId: Int
    let kitId: Int
    let receivers: Int
    let programmingQuote: String
    let processed: Bool
    let submitted: Bool
    let paid: Bool
    let syncTime: Date
    let createdAt: Date
    let updatedAt: Date?
    let account: Account

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
        syncTime = try object.value(for: Keys.syncTime)
        createdAt = try object.value(for: Keys.createdAt)
        updatedAt = try object.value(for: Keys.updatedAt)
        account = try object.value(for: Keys.account)
    }

}

struct Account: Unmarshaling {

    let id: Int
    let areaId: Int
    let firstName: String
    let lastName: String
    let phone: String
    let street: String
    let street2: String?
    let city: String
    let state: String
    let zip: String
    let email: String
    let status: String?
    let syncTime: Date
    let createdAt: Date
    let updatedAt: Date?

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        areaId = try object.value(for: Keys.areaId)
        firstName = try object.value(for: Keys.firstName)
        lastName = try object.value(for: Keys.lastName)
        phone = try object.value(for: Keys.phone)
        street = try object.value(for: Keys.street)
        street2 = try object.value(for: Keys.street2)
        city = try object.value(for: Keys.city)
        state = try object.value(for: Keys.state)
        zip = try object.value(for: Keys.zip)
        email = try object.value(for: Keys.email)
        status = try object.value(for: Keys.status)
        syncTime = try object.value(for: Keys.syncTime)
        createdAt = try object.value(for: Keys.createdAt)
        updatedAt = try object.value(for: Keys.updatedAt)
    }
    
}
