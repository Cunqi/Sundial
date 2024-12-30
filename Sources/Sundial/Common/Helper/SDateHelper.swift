//
//  SDateHelper.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

class SDateHelper {
    static let formatter: DateFormatter = .init()

    // MARK: - Internal methods

    static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }

    // MARK: - Month

    static func fetchMonth(from date: Date, calendar: Calendar) -> SMonth {
        let startOfDate = calendar.startOfDay(for: date)
        let monthForDate = calendar.dateInterval(of: .month, for: startOfDate)
        guard let startOfMonth = monthForDate?.start,
              let numOfDaysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count
        else {
            return SMonth(days: [])
        }

        let days = (0 ..< numOfDaysInMonth).compactMap { day -> SDay? in
            guard let day = calendar.date(byAdding: .day, value: day, to: startOfMonth) else {
                return nil
            }
            return SDay(date: day)
        }
        return SMonth(days: days)
    }

    static func nextMonth(from firstDayOfMonth: Date, calendar: Calendar) -> SMonth {
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth) else {
            return SMonth(days: [])
        }
        return fetchMonth(from: nextMonth, calendar: calendar)
    }

    static func previousMonth(from firstDayOfMonth: Date, calendar: Calendar) -> SMonth {
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth) else {
            return SMonth(days: [])
        }
        return fetchMonth(from: previousMonth, calendar: calendar)
    }

    static func calculateWeekday(for firstDayOfMonth: Date, calendar: Calendar) -> Int {
        calendar.component(.weekday, from: firstDayOfMonth)
    }

    // MARK: - Week

    static func fetchWeek(from date: Date, calendar: Calendar) -> SWeek {
        let startOfDate = calendar.startOfDay(for: date)
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return SWeek(days: [])
        }

        let weekdays = (0 ..< 7).compactMap { day -> SDay? in
            guard let weekDay = calendar.date(byAdding: .day, value: day, to: startOfWeek) else {
                return nil
            }
            return SDay(date: weekDay)
        }
        return SWeek(days: weekdays)
    }

    static func nextWeek(from firstDayOfWeek: Date, calendar: Calendar) -> SWeek {
        guard let nextWeek = calendar.date(byAdding: .weekOfMonth, value: 1, to: firstDayOfWeek) else {
            return SWeek(days: [])
        }
        return fetchWeek(from: nextWeek, calendar: calendar)
    }

    static func previousWeek(from firstDayOfWeek: Date, calendar: Calendar) -> SWeek {
        guard let previousWeek = calendar.date(byAdding: .weekOfMonth, value: -1, to: firstDayOfWeek) else {
            return SWeek(days: [])
        }
        return fetchWeek(from: previousWeek, calendar: calendar)
    }

    static func isToday(_ date: Date, calendar: Calendar) -> Bool {
        calendar.isDateInToday(date)
    }

    static func isSameDate(_ lhs: Date, _ rhs: Date, calendar: Calendar = .current) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }
}
