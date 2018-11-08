//
//  UserRouter.swift
//  SameDay
//
//  Created by Derik Flanary on 10/30/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Alamofire

extension Router {

    enum User: URLRequestConvertible {
        case getUser(userId: Int)

        var method: HTTPMethod {
            switch self {
            case .getUser:
                return .get
            }
        }

        var path: String {
            switch self {
            case .getUser(let userId):
                return "/employee/\(userId)/All"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getUser:
                break
            }
            return urlRequest
        }

    }

}
