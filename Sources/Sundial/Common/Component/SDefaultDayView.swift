//
//  SDefaultDayView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 1/1/25.
//

import SwiftUI

public protocol SDayView: View {
    var coordinator: SCalendarCoordinator { get }

    var day: SDay { get }
}

public struct SDefaultDayView: SDayView {
    // MARK: - Internal properties

    public var coordinator: SCalendarCoordinator

    public var day: SDay

    // MARK: - Private properties

    private var foregroundColor: Color {
        if day.isSelected {
            return .white
        } else if day.isDisabled {
            return .secondary
        } else {
            return .primary
        }
    }

    // MARK: - Initializers

    public init(coordinator: SCalendarCoordinator, day: SDay) {
        self.coordinator = coordinator
        self.day = day
    }

    public var body: some View {
        VStack(spacing: 4) {
            Text(day.date, formatter: coordinator.dayFormatter)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background {
                    if day.isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor)
                            .aspectRatio(1.0, contentMode: .fit)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .contentShape(.rect)
                .allowsHitTesting(!day.isDisabled)

            todayIndicator
        }
    }

    @ViewBuilder
    var todayIndicator: some View {
        Circle()
            .fill(Color.accentColor)
            .frame(width: 8, height: 8)
            .opacity(day.isToday(calendar: coordinator.calendar) ? 1 : 0)
    }
}
