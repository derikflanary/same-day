//
//  Date+Extensions.swift
//  SameDay
//
//  Created by Derik Flanary on 6/1/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation
import Marshal

extension Date {

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
    }

}

extension Date: ValueType {

    public static func value(from object: Any) throws -> Date {
        // handle date strings
        if let dateString = object as? String {
            guard let date = Date.fromISO8601(string: dateString) else {
                throw MarshalError.typeMismatch(expected: "ISO8601 date string", actual: dateString)
            }
            return date
        }
            // handle NSDate objects
        else if let date = object as? Date {
            return date
        }
        else {
            throw MarshalError.typeMismatch(expected: String.self, actual: type(of: object))
        }
    }
}

public extension Date {

    static fileprivate let ISO8601MillisecondFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    static fileprivate let ISO8601SecondFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    static fileprivate let ISO8601YearMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static fileprivate let formatters = [ISO8601MillisecondFormatter, ISO8601SecondFormatter, ISO8601YearMonthDayFormatter]

    static func fromISO8601(string: String) -> Date? {
        for formatter in formatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        return .none
    }
}
