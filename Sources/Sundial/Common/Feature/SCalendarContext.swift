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

    // MARK: - Private properties

    private var dataProvider: any SDayCollectionDataProvider
    private var calendarViewType: SCalendarViewType

    // MARK: - Initializers

    init(dateRange: ClosedRange<Date>, calendarViewType: SCalendarViewType) {
        self.dateRange = dateRange
        self.calendarViewType = calendarViewType
        self.dataProvider = SCalendarContext.makeDataProvider(for: calendarViewType, dateRange: dateRange)
    }

    // MARK: - Internal methods

    func item(at index: Int?) -> DayCollection? {
        items[safe: index]
    }

    func setupItems(from date: Date, calendarViewType: SCalendarViewType) {
        switchDataProviderIfNeeded(for: calendarViewType)
        guard items.isEmpty else {
            return
        }

        var initialIndex = 0
        let currentItem = dataProvider.fetchItem(for: date, calendar: coordinator.calendar)
        if let previousItem = dataProvider.fetchPreviousItem(from: currentItem, calendar: coordinator.calendar) {
            items.append(previousItem)
            initialIndex = 1
        }
        items.append(currentItem)
        if let nextItem = dataProvider.fetchNextItem(from: currentItem, calendar: coordinator.calendar) {
            items.append(nextItem)
        }
        currentItemIndex = initialIndex
    }

    func updateItemsIfNeeded(from date: Date) {
        // Check if date is out of range
        guard let currentItem else {
            return
        }
        guard let itemRange = currentItem.dateRange, !itemRange.contains(date) else {
            return
        }

        let updatedItem = dataProvider.fetchItem(for: date, calendar: coordinator.calendar)
        guard let firstDayOfCurrentItem = currentItem.days.first,
              let firstDayOfUpdatedItem = updatedItem.days.first,
              !firstDayOfCurrentItem.isSameDay(as: firstDayOfUpdatedItem, calendar: coordinator.calendar)
        else {
            return
        }
        items.removeAll()
        setupItems(from: date, calendarViewType: calendarViewType)
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
            if let previousItem = dataProvider.fetchPreviousItem(from: currentItem, calendar: coordinator.calendar) {
                items.insert(previousItem, at: 0)
                items.removeLast()
                currentItemIndex = 1
            }
        } else if currentItemIndex == items.count - 1 {
            if let nextItem = dataProvider.fetchNextItem(from: currentItem, calendar: coordinator.calendar) {
                items.append(nextItem)
                items.removeFirst()
                currentItemIndex = items.count - 2
            }
        }
    }

    func moveToPreviousIndex() {
        guard let currentItemIndex, currentItemIndex - 1 >= 0 else {
            return
        }
        self.currentItemIndex = currentItemIndex - 1
    }

    func moveToNextIndex() {
        guard let currentItemIndex, currentItemIndex + 1 < items.count else {
            return
        }
        self.currentItemIndex = currentItemIndex + 1
    }

    // MARK: - Private methods

    private static func makeDataProvider(for viewType: SCalendarViewType, dateRange: ClosedRange<Date>) -> any SDayCollectionDataProvider {
        switch viewType {
        case .month:
            return SMonthlyDayCollectionDataProvider(dateRange: dateRange)
        case .week:
            return SWeeklyDayCollectionDataProvider(dateRange: dateRange)
        }
    }

    private func switchDataProviderIfNeeded(for viewType: SCalendarViewType) {
        guard viewType != calendarViewType else {
            return
        }
        calendarViewType = viewType
        dataProvider = SCalendarContext.makeDataProvider(for: viewType, dateRange: dateRange)

        items.removeAll()
    }
}
