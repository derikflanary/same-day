//
//  AreaRouter.swift
//  SameDay
//
//  Created by Derik Flanary on 11/8/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire

extension Router {

    enum Area: URLRequestConvertible {
        case getEmployeesForArea(areaId: String)

        var method: HTTPMethod {
            switch self {
            case .getEmployeesForArea:
                return .get
            }
        }

        var path: String {
            switch self {
            case .getEmployeesForArea(let areaId):
                return "/Area/\(areaId)/Employees"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getEmployeesForArea:
                break
            }
            return urlRequest
        }

    }

}

