//
//  SWeeklyCalendarView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

public struct SWeeklyCalendarView<CalendarDayView: View>: View {
    @Environment(\.calendar) var calendar

    // MARK: - Internal properties

    @Binding var selectedDate: Date

    var dateRange: ClosedRange<Date>

    @ViewBuilder var calendarDayView: (SDay, Binding<Date>) -> CalendarDayView

    // MARK: - Private properties

    @State private var metadata = SCalendarMetadata()
    @State private var weeklyCalendarContext = SWeeklyCalendarContext()
    @State private var weekViewHeight: CGFloat = 1

    // MARK: - Initializers

    public init(selectedDate: Binding<Date>,
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture,
                @ViewBuilder calendarDayView: @escaping (SDay, Binding<Date>) -> CalendarDayView)
    {
        _selectedDate = selectedDate
        self.dateRange = dateRange
        self.calendarDayView = calendarDayView
    }

    public init(selectedDate: Binding<Date>,
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture) where CalendarDayView == SCalendarDayView
    {
        _selectedDate = selectedDate
        self.dateRange = dateRange
        calendarDayView = { day, _ in
            SCalendarDayView(day: day, selectedDate: selectedDate)
        }
    }

    public var body: some View {
        VStack(spacing: 8) {
            SCalendarWeekdayView()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .zero) {
                    ForEach(weeklyCalendarContext.items.indices, id: \.self) { index in
                        SWeeklyCalendarWeekView(
                            week: weeklyCalendarContext.items[index],
                            selectedDate: $selectedDate,
                            calendarDayView: calendarDayView
                        )
                        .containerRelativeFrame(.horizontal)
                        .onGeometryChange(for: CGFloat.self, of: {
                            $0.size.height
                        }) { newValue in
                            weekViewHeight = newValue
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $weeklyCalendarContext.currentItemIndex)
            .frame(height: weekViewHeight)
            .scrollTargetBehavior(.paging)
        }
        .environment(metadata)
        .environment(weeklyCalendarContext)
        .onAppear {
            weeklyCalendarContext.dateRange = dateRange
            weeklyCalendarContext.setupItems(from: selectedDate, calendar: calendar)
            weeklyCalendarContext.currentItemIndex = 1
        }
        .onChange(of: weeklyCalendarContext.currentItemIndex) { _, newValue in
            weeklyCalendarContext.fetchMoreItemsIfNeeded(at: newValue, calendar: calendar)
        }
    }
}

struct SWeeklyCalendarWeekView<CalendarDayView: View>: View {
    var week: SWeek

    @Binding var selectedDate: Date

    @ViewBuilder var calendarDayView: (SDay, Binding<Date>) -> CalendarDayView

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(week.days) { day in
                calendarDayView(day, $selectedDate)
            }
        }
    }
}

struct SWeeklyCalendarPreview: View {
    @Environment(\.calendar) var calendar

    @State private var currentDate: Date = .now
    @Namespace private var animation

    var body: some View {
        SWeeklyCalendarView(selectedDate: $currentDate)
    }
}

#Preview {
    SWeeklyCalendarPreview()
}
