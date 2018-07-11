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

    func weekDayMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: self)
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


extension BinaryInteger {

    var year: DateComponents {
        return years
    }

    var years: DateComponents {
        var components = DateComponents()
        components.year = Int(self.description)!
        return components
    }

    var day: DateComponents {
        return days
    }

    var days: DateComponents {
        var components = DateComponents()
        components.day = Int(self.description)!
        return components
    }

    var hour: DateComponents {
        return hours
    }

    var hours: DateComponents {
        var components = DateComponents()
        components.hour = Int(self.description)!
        return components
    }

    var minute: DateComponents {
        return minutes
    }

    var minutes: DateComponents {
        var components = DateComponents()
        components.minute = Int(self.description)!
        return components
    }

    var second: DateComponents {
        return seconds
    }

    var seconds: DateComponents {
        var components = DateComponents()
        components.second = Int(self.description)!
        return components
    }

}

extension DateComponents {

    var ago: Date {
        return before(Date())
    }

    var fromNow: Date {
        return after(Date())
    }

    func before(_ date: Date) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: self.inverted(), to: date, options: [])!
    }

    func after(_ date: Date) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: self, to: date, options: [])!
    }

    func inverted() -> DateComponents {
        var components = (self as NSDateComponents).copy() as! DateComponents

        if components.year != nil && components.year != NSDateComponentUndefined {
            components.year = -1 * components.year!
        }
        if components.month != nil && components.month != NSDateComponentUndefined {
            components.month = -1 * components.month!
        }
        if components.day != nil && components.day != NSDateComponentUndefined {
            components.day = -1 * components.day!
        }
        if components.hour != nil && components.hour != NSDateComponentUndefined {
            components.hour = -1 * components.hour!
        }
        if components.minute != nil && components.minute != NSDateComponentUndefined {
            components.minute = -1 * components.minute!
        }
        if components.second != nil && components.second != NSDateComponentUndefined {
            components.second = -1 * components.second!
        }

        return components
    }

}

