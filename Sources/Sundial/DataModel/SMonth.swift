//
//  SMonth.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

struct SMonth: SDayCollection {
    let id = UUID()

    var hasPrevious: Bool

    var hasNext: Bool

    var days: [SDay]

    var dateRange: ClosedRange<Date>? {
        guard let firstDay = days.first?.date, let lastDay = days.last?.date else {
            return nil
        }
        return firstDay ... lastDay
    }

    var numOfLeadingDays: Int {
        guard let firstDayOfMonth = days.first?.date else {
            return 0
        }
        return firstDayOfMonth.weekday(calendar: .current) - 1
    }

    // MARK: - Initializers

    init(days: [SDay] = [], hasPrevious: Bool = true, hasNext: Bool = true) {
        self.days = days
        self.hasPrevious = hasPrevious
        self.hasNext = hasNext
    }
}
