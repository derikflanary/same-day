//
//  Register.swift
//  SameDay
//
//  Created by Derik Flanary on 1/22/19.
//  Copyright © 2019 AppJester. All rights reserved.
//

import Foundation
import Alamofire

extension Router {
    
    enum Register: URLRequestConvertible {
        case register(firstName: String, lastName: String, email: String, username: String, password: String)
        
        var method: HTTPMethod {
            switch self {
            case .register:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .register:
                return "/Register"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = try path.asURL()
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            switch self {
            case let .register(firstName, lastName, email, username, password):
                let params: Parameters = [Keys.firstName: firstName,
                                          Keys.lastName: lastName,
                                          Keys.email: email,
                                          Keys.username: username,
                                          Keys.password: password]
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            }
            return urlRequest
        }
        
    }
    
}
