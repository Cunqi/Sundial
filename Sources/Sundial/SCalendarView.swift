//
//  SCalendarView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 1/1/25.
//

import SwiftUI

public enum SCalendarViewType {
    case monthly
    case weekly
}

public struct SCalendarView<DayView: SDayView>: View {
    public typealias DayViewBuilder = (SDay, SCalendarCoordinator) -> DayView

    // MARK: - Internal properties

    var metadata = SCalendarMetadata()

    var calendarViewType: SCalendarViewType

    @Binding var selectedDate: Date
    @Binding var displayDate: Date?

    @ViewBuilder var dayViewBuilder: DayViewBuilder

    // MARK: - Private properties

    @StateObject private var context: SCalendarContext

    // MARK: - Initializers

    public init(_ calendarViewType: SCalendarViewType = .monthly,
                selectedDate: Binding<Date>,
                displayDate: Binding<Date?> = .constant(nil),
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture,
                @ViewBuilder dayViewBuilder: @escaping DayViewBuilder)
    {
        self.calendarViewType = calendarViewType
        _selectedDate = selectedDate
        _displayDate = displayDate
        _context = StateObject(wrappedValue: SCalendarContext(dateRange: dateRange, calendarViewType: calendarViewType))
        self.dayViewBuilder = dayViewBuilder
    }

    public init(_ calendarViewType: SCalendarViewType = .monthly,
                selectedDate: Binding<Date>,
                displayDate: Binding<Date?> = .constant(nil),
                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture) where DayView == SDefaultDayView
    {
        self.calendarViewType = calendarViewType
        _selectedDate = selectedDate
        _displayDate = displayDate
        _context = StateObject(wrappedValue: SCalendarContext(dateRange: dateRange, calendarViewType: calendarViewType))
        dayViewBuilder = { day, coordinator in
            SDefaultDayView(coordinator: coordinator, day: day)
        }
    }

    // MARK: - Views

    public var body: some View {
        VStack {
            if calendarViewType == .monthly && !metadata.shouldHideNavBar {
                SCalendarNavBar()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: .zero) {
                    ForEach(context.items.indices, id: \.self) { index in
                        VStack {
                            SCalendarWeekdayView(metadata: metadata)
                                .fullWidth(with: metadata.spacing)
                            makeCalendarDayCollectionView(index: index)
                                .fullWidth(with: metadata.spacing)
                                .onGeometryChange(for: CGRect.self, of: {
                                    $0.frame(in: .scrollView)
                                }) { newValue in
                                    guard index == 0 else {
                                        return
                                    }
                                    let offsetX = newValue.minX.magnitude
                                    let rightMostOffsetX = newValue.width * CGFloat(context.items.count - 1) + metadata.spacing * CGFloat(context.items.count)
                                    let hasReachedBoundary = offsetX == metadata.spacing || offsetX == rightMostOffsetX
                                    if hasReachedBoundary && context.shouldFetchMoreItems {
                                        context.fetchMoreItemsIfNeeded()
                                    }
                                }
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .coordinateSpace(.scrollView)
            .scrollPosition(id: $context.currentItemIndex)
            .scrollTargetBehavior(.paging)
        }
        .environmentObject(context)
        .task {
            setupItems(from: selectedDate, calendarViewType: calendarViewType)
        }
        .onChange(of: context.currentItemIndex) { _, _ in
            context.markAsNeedsToFetchMoreItems()

            if let currentItem = context.currentItem,
               currentItem.days.contains(where: { $0.isSameDay(as: selectedDate, calendar: context.coordinator.calendar) })
            {
                displayDate = selectedDate
            } else {
                displayDate = context.currentItem?.days.first?.date
            }
        }
        .onChange(of: selectedDate) { _, newValue in
            context.updateItemsIfNeeded(from: newValue)
            displayDate = selectedDate
        }
        .onChange(of: calendarViewType) { _, _ in
            withAnimation(.snappy) {
                setupItems(from: selectedDate, calendarViewType: calendarViewType)
            }
        }
    }

    @ViewBuilder
    func makeCalendarDayCollectionView(index: Int) -> some View {
        let dayCollection = context.items[index]

        var numOfRows: Int {
            Int(ceil(Double(dayCollection.numOfLeadingDays + dayCollection.days.count) / Double(metadata.columns.count)))
        }

        var aspectRatio: Double {
            let ratio = numOfRows < 6 ? 1.5 : 1.25
            return 1 / ratio
        }

        var spacing: CGFloat {
            return numOfRows < 6 ? 10 : 8
        }

        LazyVGrid(columns: metadata.columns, spacing: spacing) {
            ForEach(0 ..< dayCollection.numOfLeadingDays, id: \.self) { _ in
                Spacer()
            }

            ForEach(dayCollection.days) { day in
                dayViewBuilder(day, context.coordinator)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedDate = day.date
                        }
                    }
            }
        }
        .transaction { transaction in
            transaction.animation = nil
        }
    }

    // MARK: - Private methods

    private func setupItems(from date: Date, calendarViewType: SCalendarViewType) {
        context.setupItems(from: date, calendarViewType: calendarViewType)
        displayDate = selectedDate
    }
}

#Preview {
    SCalendarView(selectedDate: .constant(.now))
}

// MARK: - Extensions

public extension SCalendarView {
    func hideNavBar(_ shouldHideNavBar: Bool) -> Self {
        var view = self
        view.metadata.shouldHideNavBar = shouldHideNavBar
        return view
    }
}

extension View {
    @ViewBuilder
    func fullWidth(with padding: CGFloat) -> some View {
        containerRelativeFrame(.horizontal, alignment: .center) { length, axis in
            if axis == .horizontal {
                return length - padding * 2
            } else {
                return length
            }
        }
    }
}
