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

    // MARK: - Initializers

    public init(_ calendarViewType: SCalendarViewType = .month,
                selectedDate: Binding<Date>,
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture,
                @ViewBuilder dayViewBuilder: @escaping DayViewBuilder)
    {
        self.calendarViewType = calendarViewType
        _selectedDate = selectedDate
        _context = StateObject(wrappedValue: SCalendarContext(dateRange: dateRange, calendarViewType: calendarViewType))
        self.dayViewBuilder = dayViewBuilder
    }

    public init(_ calendarViewType: SCalendarViewType = .month,
                selectedDate: Binding<Date>,
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture) where DayView == SDefaultDayView
    {
        self.calendarViewType = calendarViewType
        _selectedDate = selectedDate
        _context = StateObject(wrappedValue: SCalendarContext(dateRange: dateRange, calendarViewType: calendarViewType))
        dayViewBuilder = { day, coordinator in
            SDefaultDayView(coordinator: coordinator, day: day)
        }
    }

    // MARK: - Views

    public var body: some View {
        VStack(spacing: 8) {
            if calendarViewType == .month {
                SCalendarNavBar()
                Divider()
            }

            SCalendarWeekdayView(metadata: metadata)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: .zero) {
                    ForEach(context.items.indices, id: \.self) { index in
                        makeCalendarDayCollectionView(index: index)
                        .tag(index)
                        .containerRelativeFrame(.horizontal)
                        .onGeometryChange(for: CGRect.self, of: {
                            $0.frame(in: .scrollView)
                        }) { newValue in
                            guard index == 0 else {
                                return
                            }
                            let offsetX = newValue.minX.magnitude
                            let rightMostOffsetX = newValue.width * CGFloat(context.items.count - 1)
                            let hasReachedBoundary = offsetX == 0 || offsetX == rightMostOffsetX
                            if hasReachedBoundary && context.shouldFetchMoreItems {
                                context.fetchMoreItemsIfNeeded()
                            }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .coordinateSpace(.scrollView)
            .scrollPosition(id: $context.currentItemIndex)
            .scrollTargetBehavior(.paging)
        }
        .environmentObject(context)
        .environmentObject(metadata)
        .task(id: calendarViewType) {
            context.setupItems(from: selectedDate, calendarViewType: calendarViewType)
        }
        .onChange(of: context.currentItemIndex) { _, _ in
            context.markAsNeedsToFetchMoreItems()
        }
        .onChange(of: selectedDate) { _, newValue in
            context.updateItemsIfNeeded(from: newValue)
        }
    }

    @ViewBuilder
    func makeCalendarDayCollectionView(index: Int) -> some View {
        let dayCollection = context.items[index]

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
                    .transaction { transaction in
                        transaction.animation = .snappy
                    }
            }
        }
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}

#Preview {
    SCalendarView(selectedDate: .constant(.now))
}
