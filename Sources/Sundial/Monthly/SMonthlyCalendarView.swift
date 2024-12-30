//
//  SMonthlyCalendarView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

public struct SMonthlyCalendarView<CalendarDayView: View>: View {
    @Environment(\.calendar) var calendar

    // MARK: - Internal properties

    @Binding var selectedDate: Date

    var dateRange: ClosedRange<Date>

    @ViewBuilder var calendarDayView: (SDay, Binding<Date>) -> CalendarDayView

    // MARK: - Private properties

    @State private var metadata = SCalendarMetadata()
    @State private var context = SMonthlyCalendarContext()
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
        calendarDayView = { day, selectedDate in
            SCalendarDayView(day: day, selectedDate: selectedDate)
        }
    }

    public var body: some View {
        VStack(spacing: 8) {
            if let month = context.items[safe: context.currentItemIndex ?? 0] {
                SMonthlyCalendarNavBar(month: month)
            }
            Divider()
            SCalendarWeekdayView()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: .zero) {
                    ForEach(context.items.indices, id: \.self) { index in
                        SMonthlyCalendarMonthView(
                            month: context.items[index],
                            selectedDate: $selectedDate,
                            calendarDayView: calendarDayView
                        )
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $context.currentItemIndex)
            .scrollTargetBehavior(.paging)
            .scrollDisabled(true)
        }
        .environment(metadata)
        .environment(context)
        .onAppear {
            context.dateRange = dateRange
            context.setupItems(from: selectedDate, calendar: calendar)
            context.currentItemIndex = 1
        }
        .onChange(of: context.currentItemIndex) { _, newValue in
            context.fetchMoreItemsIfNeeded(at: newValue, calendar: calendar)
        }
    }
}

struct SMonthlyCalendarMonthView<CalendarDayView: View>: View {
    @Environment(\.calendar) var calendar
    @Environment(SMonthlyCalendarContext.self) private var context

    var month: SMonth

    @Binding var selectedDate: Date

    @ViewBuilder var calendarDayView: (SDay, Binding<Date>) -> CalendarDayView

    private var numOfLeadingDays: Int {
        guard let firstDayOfMonth = month.days.first?.date else {
            return 0
        }
        return SDateHelper.calculateWeekday(for: firstDayOfMonth, calendar: calendar) - 1
    }

    var body: some View {
        LazyVGrid(columns: context.columns) {
            ForEach(0 ..< numOfLeadingDays, id: \.self) { _ in
                Spacer()
            }
            ForEach(month.days) { day in
                calendarDayView(day, $selectedDate)
            }
        }
    }
}

struct SMonthlyCalendarViewPreview: View {
    @Environment(\.calendar) var calendar

    @State private var currentDate: Date = .now
    @Namespace private var animation

    var body: some View {
        SMonthlyCalendarView(
            selectedDate: $currentDate,
            dateRange: .now.addingTimeInterval(-60 * 60 * 24 * 45) ... .now.addingTimeInterval(60 * 60 * 24 * 45)
        )
    }
}

#Preview {
    SMonthlyCalendarViewPreview()
}
