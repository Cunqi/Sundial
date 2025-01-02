////
////  SCalendarDayView.swift
////  Sundial
////
////  Created by Cunqi Xiao on 12/29/24.
////
//
//import SwiftUI
//
//public struct SCalendarDayView: View {
//
//    // MARK: - Internal properties
//
//    var coordinator: SCalendarCoordinator
//
//    var day: SDay
//
//    private var isToday: Bool {
//        day.isToday(calendar: coordinator.calendar)
//    }
//
//    // MARK: - Initializers
//
//    public init(coordinator: SCalendarCoordinator, day: SDay) {
//        self.coordinator = coordinator
//        self.day = day
//    }
//
//    public var body: some View {
//        let _ = Self._printChanges()
//        VStack {
//            Text(day.date, formatter: SDateFeature.formatter("d"))
//                .foregroundStyle(day.isSelected ? .white : day.isDisabled ? .secondary : .primary)
//                .padding(8)
//                .frame(maxWidth: .infinity)
//                .background {
//                    if day.isSelected {
//                        Circle()
//                            .fill(.blue)
//                    }
//                }
//                .contentShape(.rect)
//                .allowsHitTesting(!day.isDisabled)
//
//            Circle()
//                .fill(.red)
//                .frame(width: 6, height: 6)
//                .opacity(isToday ? 1 : 0)
//        }
//    }
//}
