//
//  Result.swift
//  SameDay
//
//  Created by Derik Flanary on 6/6/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

public enum Result<T> {
    case ok(T)
    case error(Error)

    public func map<U>(_ f: (T) throws -> U) -> Result<U> {
        switch self {
        case let .ok(x):
            do {
                return try .ok(f(x))
            }
            catch {
                return .error(error)
            }
        case let .error(error):
            return .error(error)
        }
    }

    public func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .ok(x):
            return f(x)
        case let .error(error):
            return .error(error)
        }
    }
}
