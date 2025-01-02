//
//  SMonthlyCalendarContext.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

class SMonthlyCalendarContext: SCalendarContext {
    // MARK: - Internal properties

    override func fetchItem(for date: Date, calendar: Calendar) -> DayCollection {
        SDateFeature.makeMonth(from: date, calendar: calendar, dateRange: dateRange, selectedDate: date)
    }

    override func fetchPreviousItem(from currentItem: DayCollection, calendar: Calendar) -> DayCollection? {
        guard let firstDayOfMonth = currentItem.days.first?.date else {
            return nil
        }
        let month = SDateFeature.makePreviousMonth(from: firstDayOfMonth, calendar: calendar, dateRange: dateRange)
        guard month.dateRange?.overlaps(dateRange) ?? false else {
            return nil
        }
        return month
    }

    override func fetchNextItem(from currentItem: DayCollection, calendar: Calendar) -> DayCollection? {
        guard let firstDayOfMonth = currentItem.days.first?.date else {
            return nil
        }
        let month = SDateFeature.makeNextMonth(from: firstDayOfMonth, calendar: calendar, dateRange: dateRange)
        guard month.dateRange?.overlaps(dateRange) ?? false else {
            return nil
        }
        return month
    }
}
