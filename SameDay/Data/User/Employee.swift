//
//  Employee.swift
//  SameDay
//
//  Created by Derik Flanary on 6/19/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

struct Employee: Unmarshaling {

    enum TitleType: String {
        case admin = "Admin"
        case manager = "Manager"
        case employee = "Employee"
    }

    let id: Int
    let firstName: String
    let lastName: String
    let username: String?
    let type: TitleType
    let email: String
    let isRep: Bool
    let isTech: Bool
    let isActive: Bool
    let defaultAreaId: Int?
    let pivot: Pivot? = nil
    var employees = [Employee]()
    var areas = [Area]()


    var displayName: String {
        var fullname = "\(firstName) \(lastName)"
        fullname = fullname.lowercased()
        fullname = fullname.capitalized
        return fullname
    }

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        firstName = try object.value(for: Keys.firstName)
        lastName = try object.value(for: Keys.lastName)
        username = try object.value(for: Keys.username)
        type = try object.value(for: Keys.type)
        email = try object.value(for: Keys.email)
        isRep = try object.value(for: Keys.isRep)
        isTech = try object.value(for: Keys.isTech)
        isActive = try object.value(for: Keys.isActive)
        defaultAreaId = try object.value(for: Keys.defaultAreaId)
        areas = try object.value(for: Keys.areas)
    }

}

struct Pivot: Unmarshaling {

    let areaId: Int
    let employeeId: Int

    init(object: MarshaledObject) throws {
        areaId = try object.value(for: Keys.areaId)
        employeeId = try object.value(for: Keys.employeeId)
    }

}
