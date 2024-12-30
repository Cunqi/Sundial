//
//  SCalendarDayView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

public struct SCalendarDayView: View {
    @Environment(\.calendar) var calendar

    // MARK: - Internal properties

    var day: SDay

    @Binding var selectedDate: Date

    // MARK: - Private properties

    private var isSameDate: Bool {
        SDateHelper.isSameDate(day.date, selectedDate, calendar: calendar)
    }

    private var isToday: Bool {
        SDateHelper.isToday(day.date, calendar: calendar)
    }

    public var body: some View {
        VStack {
            Text(day.date, formatter: SDateHelper.formatter("d"))
                .foregroundStyle(isSameDate ? .white : day.isDisabled ? .secondary : .primary)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background {
                    if isSameDate {
                        Circle()
                            .fill(.blue)
                    }
                }
                .contentShape(.rect)
                .allowsHitTesting(!day.isDisabled)
                .onTapGesture {
                    withAnimation {
                        selectedDate = day.date
                    }
                }

            Circle()
                .fill(.red)
                .frame(width: 6, height: 6)
                .opacity(isToday ? 1 : 0)
        }
    }
}
