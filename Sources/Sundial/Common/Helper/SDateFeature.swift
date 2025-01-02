//
//  SDateFeature.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

class SDateFeature {
    static let formatter: DateFormatter = .init()

    // MARK: - Internal methods

    static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }

    // MARK: - Month

    static func makeMonth(from date: Date, calendar: Calendar, dateRange: ClosedRange<Date>, selectedDate: Date? = nil) -> SMonth {
        guard let startOfMonth = date.startOfMonth(calendar: calendar),
              let numOfDaysInMonth = startOfMonth.numOfDaysInMonth(calendar: calendar)
        else {
            return SMonth()
        }

        let formatter = formatter("yyyy-MM-dd")
        let days = (0 ..< numOfDaysInMonth).compactMap { day -> SDay? in
            guard let monthDay = calendar.date(byAdding: .day, value: day, to: startOfMonth) else {
                return nil
            }
            return SDay(
                id: formatter.string(from: monthDay),
                date: monthDay,
                isDisabled: !dateRange.contains(monthDay),
                isSelected: monthDay.isSameDay(as: selectedDate, calendar: calendar)
            )
        }
        return SMonth(days: days)
    }

    static func makeNextMonth(from firstDayOfMonth: Date, calendar: Calendar, dateRange: ClosedRange<Date>, selectedDate: Date? = nil) -> SMonth {
        guard let nextMonth = firstDayOfMonth.nextMonth(calendar: calendar) else {
            return SMonth()
        }
        return makeMonth(from: nextMonth, calendar: calendar, dateRange: dateRange, selectedDate: selectedDate)
    }

    static func makePreviousMonth(from firstDayOfMonth: Date, calendar: Calendar, dateRange: ClosedRange<Date>, selectedDate: Date? = nil) -> SMonth {
        guard let previousMonth = firstDayOfMonth.previousMonth(calendar: calendar) else {
            return SMonth()
        }
        return makeMonth(from: previousMonth, calendar: calendar, dateRange: dateRange, selectedDate: selectedDate)
    }

    // MARK: - Week

    static func makeWeek(from date: Date, calendar: Calendar, dateRange: ClosedRange<Date>, selectedDate _: Date?) -> SWeek {
        guard let startOfWeek = date.startOfWeek(calendar: calendar) else {
            return SWeek()
        }

        let formatter = formatter("yyyy-MM-dd")
        let weekdays = (0 ..< 7).compactMap { day -> SDay? in
            guard let weekDay = calendar.date(byAdding: .day, value: day, to: startOfWeek) else {
                return nil
            }
            return SDay(
                id: formatter.string(from: weekDay),
                date: weekDay,
                isDisabled: !dateRange.contains(weekDay),
                isSelected: weekDay.isToday(calendar: calendar)
            )
        }
        return SWeek(days: weekdays)
    }

    static func makeNextWeek(from firstDayOfWeek: Date, calendar: Calendar, dateRange: ClosedRange<Date>, selectedDate: Date? = nil) -> SWeek {
        guard let nextWeek = firstDayOfWeek.nextWeek(calendar: calendar) else {
            return SWeek()
        }
        return makeWeek(from: nextWeek, calendar: calendar, dateRange: dateRange, selectedDate: selectedDate)
    }

    static func makePreviousWeek(from firstDayOfWeek: Date, calendar: Calendar, dateRange: ClosedRange<Date>, selectedDate: Date? = nil) -> SWeek {
        guard let previousWeek = firstDayOfWeek.previousWeek(calendar: calendar) else {
            return SWeek()
        }
        return makeWeek(from: previousWeek, calendar: calendar, dateRange: dateRange, selectedDate: selectedDate)
    }
}

// MARK: - Date extension

extension Date {
    func startOfDay(calendar: Calendar) -> Date {
        calendar.startOfDay(for: self)
    }

    func startOfMonth(calendar: Calendar) -> Date? {
        calendar.dateInterval(of: .month, for: startOfDay(calendar: calendar))?.start
    }

    func numOfDaysInMonth(calendar: Calendar) -> Int? {
        guard let startOfMonth = startOfMonth(calendar: calendar) else {
            return nil
        }
        return calendar.range(of: .day, in: .month, for: startOfMonth)?.count
    }

    func nextMonth(calendar: Calendar) -> Date? {
        calendar.date(byAdding: .month, value: 1, to: self)
    }

    func previousMonth(calendar: Calendar) -> Date? {
        calendar.date(byAdding: .month, value: -1, to: self)
    }

    func weekday(calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self)
    }

    func startOfWeek(calendar: Calendar) -> Date? {
        calendar.dateInterval(of: .weekOfMonth, for: startOfDay(calendar: calendar))?.start
    }

    func nextWeek(calendar: Calendar) -> Date? {
        calendar.date(byAdding: .weekOfMonth, value: 1, to: self)
    }

    func previousWeek(calendar: Calendar) -> Date? {
        calendar.date(byAdding: .weekOfMonth, value: -1, to: self)
    }

    func isSameDay(as date: Date?, calendar: Calendar) -> Bool {
        guard let date else {
            return false
        }
        return calendar.isDate(self, inSameDayAs: date)
    }

    func isToday(calendar: Calendar) -> Bool {
        calendar.isDateInToday(self)
    }
}
