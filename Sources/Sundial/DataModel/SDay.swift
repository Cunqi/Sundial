//
//  SDay.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

public struct SDay: Equatable, Identifiable {
    public var id: String

    public var date: Date

    public var isDisabled = false

    public var isSelected = false

    // MARK: - Public methods

    public func isSameDay(as date: Date, calendar: Calendar) -> Bool {
        calendar.isDate(self.date, inSameDayAs: date)
    }

    public func isSameDay(as day: SDay, calendar: Calendar) -> Bool {
        calendar.isDate(date, inSameDayAs: day.date)
    }

    public func isToday(calendar: Calendar) -> Bool {
        calendar.isDateInToday(date)
    }

    // MARK: - Equatable

    public static func == (lhs: SDay, rhs: SDay) -> Bool {
        lhs.date == rhs.date && lhs.isDisabled == rhs.isDisabled && lhs.isSelected == rhs.isSelected
    }
}
