//
//  SCalendarContext.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

class SCalendarContext: ObservableObject {
    typealias DayCollection = any SDayCollection

    // MARK: - Internal properties

    var coordinator = SCalendarCoordinator()

    var dateRange: ClosedRange<Date>

    @Published var currentItemIndex: Int? = 0

    @Published var items: [DayCollection] = []

    @Published var shouldFetchMoreItems: Bool = false

    var currentItem: DayCollection? {
        items[safe: currentItemIndex]
    }

    // MARK: - Initializers

    init(dateRange: ClosedRange<Date>) {
        self.dateRange = dateRange
    }

    // MARK: - Internal methods

    func item(at index: Int?) -> DayCollection? {
        items[safe: index]
    }

    func setupItems(from date: Date) {
        guard items.isEmpty else {
            return
        }

        var initialIndex = 0
        let currentItem = fetchItem(for: date, calendar: coordinator.calendar)
        if let previousItem = fetchPreviousItem(from: currentItem, calendar: coordinator.calendar) {
            items.append(previousItem)
            initialIndex = 1
        }
        items.append(currentItem)
        if let nextItem = fetchNextItem(from: currentItem, calendar: coordinator.calendar) {
            items.append(nextItem)
        }
        currentItemIndex = initialIndex
    }

    func updateItemsIfNeeded(from date: Date) {
        // Check if date is out of range
        guard let currentItemIndex, let currentItem else {
            return
        }
        guard let itemRange = currentItem.dateRange, !itemRange.contains(date) else {
            let updatedCalendarItem = select(date: date, at: currentItem)
            items[currentItemIndex] = updatedCalendarItem
            return
        }

        let updatedItem = fetchItem(for: date, calendar: coordinator.calendar)
        guard let firstDayOfCurrentItem = currentItem.days.first,
              let firstDayOfUpdatedItem = updatedItem.days.first,
              !firstDayOfCurrentItem.isSameDay(as: firstDayOfUpdatedItem, calendar: coordinator.calendar)
        else {
            return
        }
        items.removeAll()
        setupItems(from: date)
    }

    func markAsNeedsToFetchMoreItems() {
        shouldFetchMoreItems = currentItemIndex == 0 || currentItemIndex == items.count - 1
    }

    func fetchMoreItemsIfNeeded() {
        defer {
            shouldFetchMoreItems = false
        }

        guard let currentItem else {
            return
        }
        if currentItemIndex == 0 {
            if let previousItem = fetchPreviousItem(from: currentItem, calendar: coordinator.calendar) {
                items.insert(previousItem, at: 0)
                items.removeLast()
                currentItemIndex = 1
            }
        } else if currentItemIndex == items.count - 1 {
            if let nextItem = fetchNextItem(from: currentItem, calendar: coordinator.calendar) {
                items.append(nextItem)
                items.removeFirst()
                currentItemIndex = items.count - 2
            }
        }
    }

    func fetchItem(for _: Date, calendar _: Calendar) -> DayCollection {
        fatalError("Subclass should override this method")
    }

    func fetchPreviousItem(from _: DayCollection, calendar _: Calendar) -> DayCollection? {
        fatalError("Subclass should override this method")
    }

    func fetchNextItem(from _: DayCollection, calendar _: Calendar) -> DayCollection? {
        fatalError("Subclass should override this method")
    }

    func select(date: Date, at item: DayCollection) -> DayCollection {
        var updatedItem = item
        if let index = updatedItem.days.firstIndex(where: { $0.isSelected }) {
            updatedItem.days[index].isSelected = false
        }

        if let index = updatedItem.days.firstIndex(where: { $0.date.isSameDay(as: date, calendar: coordinator.calendar) }) {
            updatedItem.days[index].isSelected = true
        }
        return updatedItem
    }
}
