//
//  SCalendarNavBar.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

struct SCalendarNavBar: View {
    @EnvironmentObject var context: SCalendarContext

    private var collection: SCalendarContext.DayCollection? {
        context.currentItem
    }

    private var isPreviousDisabled: Bool {
        !(collection?.hasPrevious ?? false)
    }

    private var isNextDisabled: Bool {
        !(collection?.hasNext ?? false)
    }

    var body: some View {
        HStack(spacing: 24) {
            collectionLabelView
            Spacer()
            navButtonGroup
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    var collectionLabelView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if let firstDayOfCollection = collection?.days.first?.date {
                Text(firstDayOfCollection, formatter: SCalendarDateGenerator.formatter("yyyy"))
                    .font(.body)
                    .fontWeight(.medium)
                Text(firstDayOfCollection, formatter: SCalendarDateGenerator.formatter("MMMM"))
                    .font(.title2.bold())
            }
        }
    }

    @ViewBuilder
    var navButtonGroup: some View {
        Button(action: {
            withAnimation(.snappy) {
                context.moveToPreviousIndex()
            }
        }) {
            Image(systemName: "chevron.left")
        }
        .disabled(isPreviousDisabled)

        Button(action: {
            withAnimation(.snappy) {
                context.moveToNextIndex()
            }
        }) {
            Image(systemName: "chevron.right")
        }
        .disabled(isNextDisabled)
    }
}
