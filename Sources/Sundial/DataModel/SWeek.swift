//
//  SWeek.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

struct SWeek: SDayCollection {
    let id = UUID()

    var days: [SDay]

    var hasPrevious: Bool = true

    var hasNext: Bool = true

    var dateRange: ClosedRange<Date>? {
        guard let firstDay = days.first?.date, let lastDay = days.last?.date else {
            return nil
        }
        return firstDay ... lastDay
    }

    var numOfLeadingDays: Int {
        0
    }

    // MARK: - Initializers

    init(days: [SDay] = [], hasPrevious: Bool = true, hasNext: Bool = true) {
        self.days = days
        self.hasPrevious = hasPrevious
        self.hasNext = hasNext
    }

    func updateDisabledDays(with _: ClosedRange<Date>) -> SWeek {
        self
    }
}
