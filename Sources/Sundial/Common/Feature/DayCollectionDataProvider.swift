//
//  DayCollectionDataProvider.swift
//  Sundial
//
//  Created by Cunqi Xiao on 1/1/25.
//

import Foundation

protocol SDayCollectionDataProvider where DayCollection: SDayCollection {
    associatedtype DayCollection
    var dateRange: ClosedRange<Date> { get }

    func fetchItem(for _: Date, calendar _: Calendar) -> DayCollection

    func fetchPreviousItem(from _: any SDayCollection, calendar _: Calendar) -> DayCollection?

    func fetchNextItem(from _: any SDayCollection, calendar _: Calendar) -> DayCollection?
}

// MARK: - MonthlyDayCollectionDataProvider

class SMonthlyDayCollectionDataProvider: SDayCollectionDataProvider {

    // MARK: - Internal properties

    var dateRange: ClosedRange<Date>

    // MARK: - Initializers

    init(dateRange: ClosedRange<Date>) {
        self.dateRange = dateRange
    }

    // MARK: - Internal methods

    func fetchItem(for date: Date, calendar: Calendar) -> SMonth {
        SCalendarDateGenerator.makeMonth(from: date, calendar: calendar, dateRange: dateRange, selectedDate: date)
    }

    func fetchPreviousItem(from currentItem: any SDayCollection, calendar: Calendar) -> SMonth? {
        guard let firstDayOfMonth = currentItem.days.first?.date else {
            return nil
        }
        let month = SCalendarDateGenerator.makePreviousMonth(from: firstDayOfMonth, calendar: calendar, dateRange: dateRange)
        guard month.dateRange?.overlaps(dateRange) ?? false else {
            return nil
        }
        return month
    }

    func fetchNextItem(from currentItem: any SDayCollection, calendar: Calendar) -> SMonth? {
        guard let firstDayOfMonth = currentItem.days.first?.date else {
            return nil
        }
        let month = SCalendarDateGenerator.makeNextMonth(from: firstDayOfMonth, calendar: calendar, dateRange: dateRange)
        guard month.dateRange?.overlaps(dateRange) ?? false else {
            return nil
        }
        return month
    }
}

// MARK: - WeeklyDayCollectionDataProvider

class SWeeklyDayCollectionDataProvider: SDayCollectionDataProvider {
    // MARK: - Internal properties

    var dateRange: ClosedRange<Date>

    // MARK: - Initializers

    init(dateRange: ClosedRange<Date>) {
        self.dateRange = dateRange
    }

    // MARK: - Internal methods

    func fetchItem(for date: Date, calendar: Calendar) -> SWeek {
        SCalendarDateGenerator.makeWeek(from: date, calendar: calendar, dateRange: dateRange, selectedDate: date)
    }

    func fetchNextItem(from currentItem: any SDayCollection, calendar: Calendar) -> SWeek? {
        guard let firstDayOfWeek = currentItem.days.first?.date else {
            return nil
        }
        let week = SCalendarDateGenerator.makeNextWeek(from: firstDayOfWeek, calendar: calendar, dateRange: dateRange)
        guard week.days.contains(where: { !$0.isDisabled }) else {
            return nil
        }
        return week
    }

    func fetchPreviousItem(from currentItem: any SDayCollection, calendar: Calendar) -> SWeek? {
        guard let firstDayOfWeek = currentItem.days.first?.date else {
            return nil
        }
        let week = SCalendarDateGenerator.makePreviousWeek(from: firstDayOfWeek, calendar: calendar, dateRange: dateRange)
        guard week.days.contains(where: { !$0.isDisabled }) else {
            return nil
        }
        return week
    }
}
