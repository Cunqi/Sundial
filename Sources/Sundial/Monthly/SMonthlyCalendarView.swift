////
////  SMonthlyCalendarView.swift
////  Sundial
////
////  Created by Cunqi Xiao on 12/29/24.
////
//
//import SwiftUI
//public struct SMonthlyCalendarView<CalendarDayView: View>: View {
//    public typealias CalendarDayMaker = (SDay, SCalendarCoordinator) -> CalendarDayView
//    // MARK: - Internal properties
//
//    @Binding var selectedDate: Date?
//
//    var dateRange: ClosedRange<Date>
//
//    @ViewBuilder var calendarDayView: CalendarDayMaker
//
//    // MARK: - Private properties
//
//    @State private var currentItemIndex: Int?
//    @State private var metadata: SCalendarMetadata?
//    @State private var context: SMonthlyCalendarContext?
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
//                dateRange: ClosedRange<Date> = .distantPast ... Date.distantFuture) where CalendarDayView == SCalendarDayView {
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
//            if let context, let currentMonth = context.item(at: currentItemIndex) {
//                SMonthlyCalendarNavBar(
//                    context: context,
//                    month: currentMonth,
//                    currentItemIndex: $currentItemIndex
//                ) 
//            }
//            Divider()
//            if let metadata {
//                SCalendarWeekdayView(metadata: metadata)
//            }
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(alignment: .top, spacing: .zero) {
//                    if let context {
//                        ForEach(context.items.indices, id: \.self) { index in
//                            SMonthlyCalendarMonthView(
//                                context: context,
//                                month: context.items[index],
//                                selectedDate: $selectedDate,
//                                calendarDayView: calendarDayView
//                            )
//                            .id(index)
//                            .containerRelativeFrame(.horizontal)
//                        }
//                    }
//                }
//                .scrollTargetLayout()
//            }
//            .scrollPosition(id: $currentItemIndex)
//            .scrollTargetBehavior(.paging)
//            .scrollDisabled(true)
//        }
//        .task {
//            metadata = SCalendarMetadata()
//            let context = SMonthlyCalendarContext(dateRange: dateRange)
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
//               let updatedItemIndex = context?.updateItemsIfNeeded(from: newValue, at: currentItemIndex) {
//                self.currentItemIndex = updatedItemIndex
//            }
//        }
//    }
//}
//
//struct SMonthlyCalendarMonthView<CalendarDayView: View>: View {
//    var context: SMonthlyCalendarContext
//    var month: SMonth
//
//    @Binding var selectedDate: Date?
//    @ViewBuilder var calendarDayView: SMonthlyCalendarView<CalendarDayView>.CalendarDayMaker
//
//    // MARK: - Private properties
//
//    init(context: SMonthlyCalendarContext,
//         month: SMonth,
//         selectedDate: Binding<Date?>,
//         @ViewBuilder calendarDayView: @escaping SMonthlyCalendarView<CalendarDayView>.CalendarDayMaker)
//    {
//        self.context = context
//        self.month = month
//        self._selectedDate = selectedDate
//        self.calendarDayView = calendarDayView
//    }
//
//    private var numOfLeadingDays: Int {
//        guard let firstDayOfMonth = month.days.first?.date else {
//            return 0
//        }
//        return firstDayOfMonth.weekday(calendar: context.coordinator.calendar) - 1
//    }
//
//    var body: some View {
//        let _ = Self._printChanges()
//        LazyVGrid(columns: context.columns) {
//            ForEach(0 ..< numOfLeadingDays, id: \.self) { _ in
//                Spacer()
//            }
//            ForEach(month.days) { day in
//                calendarDayView(day, context.coordinator)
//                    .onTapGesture {
//                        selectedDate = day.date
//                    }
//            }
//        }
//    }
//}
//
//public struct SMonthlyCalendarViewPreview: View {
//    @State private var currentDate: Date? = .now
//    @Namespace private var animation
//
//    public var body: some View {
//        SMonthlyCalendarView(
//            selectedDate: $currentDate
//        )
//    }
//
//    public init() {}
//}
//
//#Preview {
//    SMonthlyCalendarViewPreview()
//}
