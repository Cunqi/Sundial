//
//  SWeeklyCalendarContext.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

@Observable class SWeeklyCalendarContext: SCalendarContext<SWeek> {
    // MARK: - Internal methods

    override func fetchCurrentItem(from date: Date, calendar: Calendar) -> SWeek {
        SDateHelper.fetchWeek(from: date, calendar: calendar)
    }

    override func fetchNextItem(from currentItem: SWeek, calendar: Calendar) -> SWeek? {
        guard let firstDayOfWeek = currentItem.days.first?.date else {
            return nil
        }
        let week = SDateHelper.nextWeek(from: firstDayOfWeek, calendar: calendar)
        guard week.days.contains(where: { !$0.isDisabled }) else {
            return nil
        }
        return week
    }

    override func fetchPreviousItem(from currentItem: SWeek, calendar: Calendar) -> SWeek? {
        guard let firstDayOfWeek = currentItem.days.first?.date else {
            return nil
        }
        let week = SDateHelper.previousWeek(from: firstDayOfWeek, calendar: calendar)
        guard week.days.contains(where: { !$0.isDisabled }) else {
            return nil
        }
        return week
    }
}
