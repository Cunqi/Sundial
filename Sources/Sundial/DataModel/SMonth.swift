//
//  SMonth.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

struct SMonth: SDayCollection {
    let id = UUID()

    var hasPrevious = true

    var hasNext = true

    var days: [SDay]

    var dateRange: ClosedRange<Date>? {
        guard let firstDay = days.first?.date, let lastDay = days.last?.date else {
            return nil
        }
        return firstDay ... lastDay
    }

    // MARK: - Internal methods

    func updateDisabledDays(with dateRange: ClosedRange<Date>) -> SMonth {
        guard let firstDay = days.first?.date, let lastDay = days.last?.date else {
            return self
        }
        let hasPrevious = dateRange.lowerBound < firstDay
        let hasNext = dateRange.upperBound > lastDay

        return SMonth(
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            days: days.map { day in
                let isDisabled = !dateRange.contains(day.date)
                return SDay(date: day.date, isDisabled: isDisabled)
            }
        )
    }
}
