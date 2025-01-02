////
////  SWeeklyCalendarView.swift
////  Sundial
////
////  Created by Cunqi Xiao on 12/29/24.
////
//
//import SwiftUI
//
//public struct SWeeklyCalendarView<CalendarDayView: View>: View {
//    public typealias CalendarDayMaker = (SDay, SCalendarCoordinator) -> CalendarDayView
//
//    // MARK: - Internal properties
//
//    @Binding var selectedDate: Date?
//
//    var dateRange: ClosedRange<Date>
//
//    @ViewBuilder var calendarDayView: (SDay, SCalendarCoordinator) -> CalendarDayView
//
//    // MARK: - Private properties
//
//    @State private var currentItemIndex: Int?
//    @State private var metadata: SCalendarMetadata?
//    @State private var context: SWeeklyCalendarContext?
//    @State private var weekViewHeight: CGFloat = 1
//
//    // MARK: - Initializers
//
//    public init(selectedDate: Binding<Date?>,
//                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture,
//                @ViewBuilder calendarDayView: @escaping CalendarDayMaker)
//    {
//        _selectedDate = selectedDate
//        self.dateRange = dateRange
//        self.calendarDayView = calendarDayView
//    }
//
//    public init(selectedDate: Binding<Date?>,
//                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture) where CalendarDayView == SCalendarDayView
//    {
//        _selectedDate = selectedDate
//        self.dateRange = dateRange
//        calendarDayView = { day, coordinator in
//            SCalendarDayView(coordinator: coordinator, day: day)
//        }
//    }
//
//    public var body: some View {
//        let _ = Self._printChanges()
//        VStack(spacing: 8) {
//            if let metadata {
//                SCalendarWeekdayView(metadata: metadata)
//            }
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: .zero) {
//                    if let context {
//                        ForEach(context.items.indices, id: \.self) { index in
//                            SWeeklyCalendarWeekView(
//                                context: context,
//                                week: context.items[index],
//                                calendarDayView: calendarDayView)
//                            .containerRelativeFrame(.horizontal)
//                            .onGeometryChange(for: CGFloat.self, of: {
//                                $0.size.height
//                            }) { newValue in
//                                weekViewHeight = newValue
//                            }
//                        }
//                    }
//                }
//                .scrollTargetLayout()
//            }
//            .scrollPosition(id: $currentItemIndex)
//            .frame(height: weekViewHeight)
//            .scrollTargetBehavior(.paging)
//        }
//        .task {
//            metadata = SCalendarMetadata()
//            let context = SWeeklyCalendarContext(dateRange: dateRange)
//            let currentItemIndex = context.setupItems(from: selectedDate ?? .now)
//            self.context = context
//            self.currentItemIndex = currentItemIndex
//        }
//        .onChange(of: currentItemIndex) { _, newValue in
//            if let updatedItemIndex = context?.fetchMoreItemsIfNeeded(at: newValue) {
//                self.currentItemIndex = updatedItemIndex
//            }
//        }
//        .onChange(of: selectedDate) { _, newValue in
//            if let newValue,
//               let updatedItemIndex = context?.updateItemsIfNeeded(from: newValue, at: currentItemIndex)
//            {
//                self.currentItemIndex = updatedItemIndex
//            }
//        }
//    }
//}
//
//struct SWeeklyCalendarWeekView<CalendarDayView: View>: View {
//    var context: SWeeklyCalendarContext
//
//    var week: SWeek
//
//    @ViewBuilder var calendarDayView: SWeeklyCalendarView<CalendarDayView>.CalendarDayMaker
//
//    // MARK: - Initializers
//
//    init(context: SWeeklyCalendarContext,
//         week: SWeek,
//         @ViewBuilder calendarDayView: @escaping SWeeklyCalendarView<CalendarDayView>.CalendarDayMaker)
//    {
//        self.context = context
//        self.week = week
//        self.calendarDayView = calendarDayView
//    }
//
//    // MARK: - Body
//
//    var body: some View {
//        HStack(spacing: .zero) {
//            ForEach(week.days) { day in
//                calendarDayView(day, context.coordinator)
//            }
//        }
//    }
//}
//
//struct SWeeklyCalendarPreview: View {
//    @State private var currentDate: Date? = .now
//    @Namespace private var animation
//
//    var body: some View {
//        SWeeklyCalendarView(selectedDate: $currentDate)
//    }
//}
//
//#Preview {
//    SWeeklyCalendarPreview()
//}
