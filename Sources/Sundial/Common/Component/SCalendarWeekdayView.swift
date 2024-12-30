//
//  SCalendarWeekdayView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

struct SCalendarWeekdayView: View {
    @Environment(SCalendarMetadata.self) var metadata

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(metadata.weekdaySymbols.map { SWeekdaySymbol(symbol: $0) }) { weekday in
                Text(weekday.symbol)
                    .font(metadata.itemFont.bold())
                    .foregroundColor(metadata.weekdayColor)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    SCalendarWeekdayView()
        .environment(SCalendarMetadata())
}