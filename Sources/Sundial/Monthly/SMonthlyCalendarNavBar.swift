//
//  SMonthlyCalendarNavBar.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

struct SMonthlyCalendarNavBar: View {
    @Environment(\.calendar) var calendar
    @Environment(SMonthlyCalendarContext.self) var context

    var month: SMonth

    var body: some View {
        HStack(spacing: 24) {
            monthLabelView
            Spacer()
            navButtonGroup
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var monthLabelView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let firstDayOfMonth = month.days.first?.date {
                Text(firstDayOfMonth, formatter: SDateHelper.formatter("yyyy"))
                    .font(.caption)
                Text(firstDayOfMonth, formatter: SDateHelper.formatter("MMMM"))
                    .font(.title.bold())
            }
        }
    }

    @ViewBuilder
    var navButtonGroup: some View {
        Button(action: {
            withAnimation {
                context.moveToPreviousItem()
            }
        }) {
            Image(systemName: "chevron.left")
        }
        .disabled(!month.hasPrevious)

        Button(action: {
            withAnimation {
                context.moveToNextItem()
            }
        }) {
            Image(systemName: "chevron.right")
        }
        .disabled(!month.hasNext)
    }
}
