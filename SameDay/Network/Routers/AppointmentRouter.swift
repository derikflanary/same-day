//
//  AppointmentRouter.swift
//  SameDay
//
//  Created by Derik Flanary on 10/29/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire

enum Router { }

extension Router {

    enum Appointment: URLRequestConvertible {
        case getAppointments(userId: Int)

        var method: HTTPMethod {
            switch self {
            case .getAppointments:
                return .get
            }
        }

        var path: String {
            switch self {
            case .getAppointments(let userId):
                return "/employee/\(userId)/open_appointments"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getAppointments:
                break
            }
            return urlRequest
        }
    }

}
