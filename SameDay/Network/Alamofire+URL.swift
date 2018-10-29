//
//  Alamofire+URL.swift
//  align
//
//  Created by Tim on 1/12/18.
//  Copyright © 2018 OC Tanner. All rights reserved.
//

import Foundation
import Alamofire


struct BaseURLConvertible: URLConvertible {

    let baseURL: URLConvertible
    let original: URLConvertible

    func asURL() throws -> URL {
        let base = try baseURL.asURL()
        let orig = try original.asURL()
        guard let url = orig.based(at: base) else { throw AFError.invalidURL(url: self) }
        return url
    }

}

extension URLConvertible {

    func from(_ baseURL: URLConvertible) -> URLConvertible {
        return BaseURLConvertible(baseURL: baseURL, original: self)
    }

}

extension URL {
    func based(at base: URL?) -> URL? {
        guard let base = base else { return self }
        guard let baseComponents = URLComponents(string: base.absoluteString) else { return self }
        guard var components = URLComponents(string: self.absoluteString) else { return self }
        guard components.scheme == nil else { return self }

        components.scheme = baseComponents.scheme
        components.host = baseComponents.host
        components.port = baseComponents.port
        components.path = baseComponents.path + components.path
        return components.url
    }
}
