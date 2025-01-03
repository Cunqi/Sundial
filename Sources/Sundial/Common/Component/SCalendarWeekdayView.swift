//
//  SCalendarWeekdayView.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import SwiftUI

struct SCalendarWeekdayView: View {
    var metadata: SCalendarMetadata

    var body: some View {
        HStack(spacing: metadata.spacing) {
            ForEach(metadata.weekdaySymbols.map { SWeekdaySymbol(symbol: $0) }) { weekday in
                Text(weekday.symbol)
                    .font(.footnote.bold())
                    .foregroundColor(metadata.weekdayColor)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    SCalendarWeekdayView(metadata: SCalendarMetadata())
}
