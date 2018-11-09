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

        var method: HTTPMethod {
            switch self {
            case .getAllAppointments, .getAppointmentsForArea:
                return .get
            }
        }

        var path: String {
            switch self {
            case .getAllAppointments(let userId):
                return "/Appointments/Open/\(userId)"
            case .getAppointmentsForArea(let areaId):
                return "/Area/\(areaId)/OpenAppointments"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getAllAppointments, .getAppointmentsForArea:
                break
            }
            return urlRequest
        }
        
    }

}
