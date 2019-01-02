//
//  AppointmentRouter.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire

extension Router {

    enum Appointment: URLRequestConvertible {
        case getAllAppointments(userId: Int)
        case getAppointmentsForArea(areaId: Int)
        case postAppointmentUpdate(employeeId: Int?, appointmentId: Int, updateType: String)

        var method: HTTPMethod {
            switch self {
            case .getAllAppointments, .getAppointmentsForArea:
                return .get
            case .postAppointmentUpdate:
                return .post
            }
        }

        var path: String {
            switch self {
            case .getAllAppointments(let userId):
                return "/Appointments/\(userId)"
            case .getAppointmentsForArea(let areaId):
                return "/Area/\(areaId)/OpenAppointments"
            case .postAppointmentUpdate:
                return "/Appointment/Update"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getAllAppointments, .getAppointmentsForArea:
                break
            case let .postAppointmentUpdate(employeeId, appointmentId, updateType):
                var params: Parameters = [Keys.id: appointmentId,
                                          Keys.result: updateType]
                if let employeeId = employeeId {
                    params[Keys.employeeid] = employeeId
                }
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            }
            return urlRequest
        }
        
    }

}
