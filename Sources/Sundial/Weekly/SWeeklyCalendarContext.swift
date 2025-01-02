//
//  SWeeklyCalendarContext.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

class SWeeklyCalendarContext: SCalendarContext {
    // MARK: - Internal methods

    override func fetchItem(for date: Date, calendar: Calendar) -> DayCollection {
        SDateFeature.makeWeek(from: date, calendar: calendar, dateRange: dateRange, selectedDate: date)
    }

    override func fetchNextItem(from currentItem: DayCollection, calendar: Calendar) -> DayCollection? {
        guard let firstDayOfWeek = currentItem.days.first?.date else {
            return nil
        }
        let week = SDateFeature.makeNextWeek(from: firstDayOfWeek, calendar: calendar, dateRange: dateRange)
        guard week.days.contains(where: { !$0.isDisabled }) else {
            return nil
        }
        return week
    }

    override func fetchPreviousItem(from currentItem: DayCollection, calendar: Calendar) -> DayCollection? {
        guard let firstDayOfWeek = currentItem.days.first?.date else {
            return nil
        }
        let week = SDateFeature.makePreviousWeek(from: firstDayOfWeek, calendar: calendar, dateRange: dateRange)
        guard week.days.contains(where: { !$0.isDisabled }) else {
            return nil
        }
        return week
    }
}
