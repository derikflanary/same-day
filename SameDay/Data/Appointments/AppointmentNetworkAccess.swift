//
//  AppointmentNetworkAccess.swift
//  SameDay
//
//  Created by Derik Flanary on 6/20/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire
import Marshal

protocol AppointmentNetworkAccess {
    func getAppointments(for id: Int, completion: @escaping (_ objectJSON: DataResponse<Any>?) -> Void)
    func getUnassignedAppointments(for areaId: Int, completion: @escaping (_ objectJSON: DataResponse<Any>?) -> Void)
    func geocode(address: String, completion: @escaping (DataResponse<Any>?) -> Void)
}


struct AppointmentNetworkAPIAccess: AppointmentNetworkAccess {

    typealias networkCompletion = (_ objectJSON: DataResponse<Any>?) -> Void

    // MARK: - Shared instance

    static let sharedInstance = AppointmentNetworkAPIAccess()
    let baseURLString = "https://dishpros.quicktechapp.com"
    let headers: HTTPHeaders = [
        "Authorization": "Bearer d8923yur9238rh4398rh32p8eij38heruq3hep8wu4fhuiefbdsjvbndskjfbudfbq39eqy28eq"
    ]

    func getAppointments(for id: Int, completion: @escaping (DataResponse<Any>?) -> Void) {
        Alamofire.request("\(baseURLString)/employee/\(id)/open_appointments", method: .get, headers: headers).responseJSON(completionHandler: completion)
    }

    func getUnassignedAppointments(for areaId: Int, completion: @escaping (DataResponse<Any>?) -> Void) {
        let params: Parameters = [Keys.areaId: areaId]

        Alamofire.request("\(baseURLString)/appointments/unassigned", method: .get, parameters: params, headers: headers).responseJSON(completionHandler: completion)
    }

    func geocode(address: String, completion: @escaping (DataResponse<Any>?) -> Void) {
        let params: Parameters = [Keys.address: address,
                                  Keys.key: "AIzaSyAq3VuWNyJb8mqAdid3GGfa61JeAU4_Kkw"]
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: params).responseJSON(completionHandler: completion)

    }

}
