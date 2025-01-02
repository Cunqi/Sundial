//
//  SCalendarMetadata.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/28/24.
//

import SwiftUI

public class SCalendarMetadata: ObservableObject {

    @Published public var weekdaySymbols: [String] = SDateFeature.formatter.veryShortWeekdaySymbols

    @Published public var itemFont: Font = .body

    @Published public var weekdayColor: Color = .secondary

    let columns = Array(repeating: GridItem(.flexible(), spacing: .zero), count: 7)

}
