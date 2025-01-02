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
        .padding(.horizontal)
    }

    @ViewBuilder
    var collectionLabelView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if let firstDayOfCollection = collection?.days.first?.date {
                Text(firstDayOfCollection, formatter: SDateFeature.formatter("yyyy"))
                    .font(.caption)
                Text(firstDayOfCollection, formatter: SDateFeature.formatter("MMMM"))
                    .font(.title.bold())
            }
        }
    }

    @ViewBuilder
    var navButtonGroup: some View {
        Button(action: {
            withAnimation {
                moveToPreviousItem()
            }
        }) {
            Image(systemName: "chevron.left")
        }
        .disabled(isPreviousDisabled)

        Button(action: {
            withAnimation {
                moveToNextItem()
            }
        }) {
            Image(systemName: "chevron.right")
        }
        .disabled(isNextDisabled)
    }

    // MARK: - Private methods

    private func moveToPreviousItem() {
        context.currentItemIndex -= 1
    }

    private func moveToNextItem() {
        context.currentItemIndex += 1
    }
}
