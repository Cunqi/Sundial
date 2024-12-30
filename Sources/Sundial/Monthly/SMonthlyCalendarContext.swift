//
//  SMonthlyCalendarContext.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

@Observable class SMonthlyCalendarContext: SCalendarContext<SMonth> {
    // MARK: - Internal properties

    let columns = Array(repeating: GridItem(.flexible(), spacing: .zero), count: 7)

    override func fetchCurrentItem(from date: Date, calendar: Calendar) -> SMonth {
        SDateHelper.fetchMonth(from: date, calendar: calendar)
            .updateDisabledDays(with: dateRange)
    }

    override func fetchPreviousItem(from currentItem: SMonth, calendar: Calendar) -> SMonth? {
        guard let firstDayOfMonth = currentItem.days.first?.date else {
            return nil
        }
        let month = SDateHelper.previousMonth(from: firstDayOfMonth, calendar: calendar)
        guard month.dateRange?.overlaps(dateRange) ?? false else {
            return nil
        }
        return month.updateDisabledDays(with: dateRange)
    }

    override func fetchNextItem(from currentItem: SMonth, calendar: Calendar) -> SMonth? {
        guard let firstDayOfMonth = currentItem.days.first?.date else {
            return nil
        }
        let month = SDateHelper.nextMonth(from: firstDayOfMonth, calendar: calendar)
        guard month.dateRange?.overlaps(dateRange) ?? false else {
            return nil
        }
        return month.updateDisabledDays(with: dateRange)
    }
}
