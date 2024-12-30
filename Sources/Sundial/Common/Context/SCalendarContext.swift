//
//  SCalendarContext.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

@Observable class SCalendarContext<CalendarItem: SDayCollection> {
    var items: [CalendarItem] = []

    var dateRange: ClosedRange<Date> = .distantPast ... .distantFuture

    var currentItemIndex: Int?

    // MARK: - Internal methods

    func setupItems(from date: Date, calendar: Calendar) {
        guard items.isEmpty else {
            return
        }

        let currentItem = fetchCurrentItem(from: date, calendar: calendar)

        if let previousItem = fetchPreviousItem(from: currentItem, calendar: calendar) {
            items.append(previousItem)
        }

        items.append(currentItem)

        if let nextItem = fetchNextItem(from: currentItem, calendar: calendar) {
            items.append(nextItem)
        }
    }

    func fetchMoreItemsIfNeeded(at index: Int?, calendar: Calendar) {
        guard index == items.count - 1 || index == 0,
              let itemAtIndex = items[safe: index ?? 0]
        else {
            return
        }
        if index == 0 {
            if let previousItem = fetchPreviousItem(from: itemAtIndex, calendar: calendar) {
                items.insert(previousItem, at: 0)
                items.removeLast()
                currentItemIndex = 1
            }
        } else if index == items.count - 1 {
            if let nextItem = fetchNextItem(from: itemAtIndex, calendar: calendar) {
                items.append(nextItem)
                items.removeFirst()
                currentItemIndex = items.count - 2
            }
        }
    }

    func fetchCurrentItem(from _: Date, calendar _: Calendar) -> CalendarItem {
        fatalError("Subclass should override this method")
    }

    func fetchPreviousItem(from _: CalendarItem, calendar _: Calendar) -> CalendarItem? {
        fatalError("Subclass should override this method")
    }

    func fetchNextItem(from _: CalendarItem, calendar _: Calendar) -> CalendarItem? {
        fatalError("Subclass should override this method")
    }

    func moveToPreviousItem() {
        guard let currentItemIndex else {
            return
        }
        self.currentItemIndex = currentItemIndex - 1
    }

    func moveToNextItem() {
        guard let currentItemIndex else {
            return
        }
        self.currentItemIndex = currentItemIndex + 1
    }
}
