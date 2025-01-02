//
//  SCalendarView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 1/1/25.
//

import SwiftUI

public enum SCalendarViewType {
    case month
    case week
}

public struct SCalendarView<DayView: SDayView>: View {
    public typealias DayViewBuilder = (SDay, SCalendarCoordinator) -> DayView

    // MARK: - Internal properties

    var calendarViewType: SCalendarViewType

    @Binding var selectedDate: Date

    @ViewBuilder var dayViewBuilder: DayViewBuilder

    // MARK: - Private properties

    @StateObject private var context: SCalendarContext
    @StateObject private var metadata = SCalendarMetadata()
    @State private var tabViewHeight: CGFloat = 1
    @State private var tabViewMinX: CGFloat = 0

    // MARK: - Initializers

    public init(_ calendarViewType: SCalendarViewType = .month,
                selectedDate: Binding<Date>,
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture,
                @ViewBuilder dayViewBuilder: @escaping DayViewBuilder)
    {
        self.calendarViewType = calendarViewType
        _selectedDate = selectedDate
        _context = StateObject(wrappedValue: SCalendarView.makeCalendarContext(for: calendarViewType, dateRange: dateRange))
        self.dayViewBuilder = dayViewBuilder
    }

    public init(_ calendarViewType: SCalendarViewType = .month,
                selectedDate: Binding<Date>,
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture) where DayView == SDefaultDayView
    {
        self.calendarViewType = calendarViewType
        _selectedDate = selectedDate
        _context = StateObject(wrappedValue: SCalendarView.makeCalendarContext(for: calendarViewType, dateRange: dateRange))
        dayViewBuilder = { day, coordinator in
            SDefaultDayView(coordinator: coordinator, day: day)
        }
    }

    // MARK: - Views

    public var body: some View {
        let _ = Self._printChanges()
        VStack(spacing: 8) {
            if calendarViewType == .month {
                SCalendarNavBar()
                Divider()
            }

            SCalendarWeekdayView(metadata: metadata)

            TabView(selection: $context.currentItemIndex) {
                ForEach(context.items.indices, id: \.self) { index in
                    SCalendarDayCollectionView(
                        index: index,
                        selectedDate: $selectedDate,
                        dayViewBuilder: dayViewBuilder
                    )
                    .tag(index)
                    .containerRelativeFrame(.horizontal)
                    .onGeometryChange(for: CGFloat.self, of: {
                        $0.size.height
                    }) { newValue in
                        tabViewHeight = newValue
                    }
                    .onGeometryChange(for: CGFloat.self, of: {
                        $0.frame(in: .global).minX
                    }) { newValue in
                        if newValue.rounded() == tabViewMinX.rounded() && context.shouldFetchMoreItems {
                            context.fetchMoreItemsIfNeeded()
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: tabViewHeight)
            .onGeometryChange(for: CGFloat.self, of: {
                $0.frame(in: .global).minX
            }) { newValue in
                tabViewMinX = newValue
            }
        }
        .environmentObject(context)
        .environmentObject(metadata)
        .task {
            context.setupItems(from: selectedDate)
        }
        .onChange(of: context.currentItemIndex) { _, _ in
            context.markAsNeedsToFetchMoreItems()
        }
        .onChange(of: selectedDate) { _, newValue in
            context.updateItemsIfNeeded(from: newValue)
        }
    }

    // MARK: - Private methods

    private static func makeCalendarContext(for viewType: SCalendarViewType, dateRange: ClosedRange<Date>) -> SCalendarContext {
        switch viewType {
        case .month:
            return SMonthlyCalendarContext(dateRange: dateRange)
        case .week:
            return SWeeklyCalendarContext(dateRange: dateRange)
        }
    }
}

struct SCalendarDayCollectionView<DayView: SDayView>: View {
    @EnvironmentObject var metadata: SCalendarMetadata
    @EnvironmentObject var context: SCalendarContext

    // MARK: - Internal properties

    var index: Int

    var dayCollection: SCalendarContext.DayCollection {
        context.items[index]
    }

    @Binding var selectedDate: Date

    var dayViewBuilder: SCalendarView<DayView>.DayViewBuilder

    var body: some View {
        let _ = Self._printChanges()
        LazyVGrid(columns: metadata.columns, spacing: .zero) {
            ForEach(0 ..< dayCollection.numOfLeadingDays, id: \.self) { _ in
                Spacer()
            }

            ForEach(dayCollection.days) { day in
                dayViewBuilder(day, context.coordinator)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedDate = day.date
                        }
                    }
            }
        }
    }
}

#Preview {
    SCalendarView(selectedDate: .constant(.now))
}
