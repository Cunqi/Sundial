//
//  SCalendarMetadata.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/28/24.
//

import SwiftUI

public struct SCalendarMetadata {

    public var weekdaySymbols: [String] = SCalendarDateGenerator.formatter.veryShortWeekdaySymbols

    public var weekdayColor: Color = .secondary

    public var shouldHideNavBar: Bool = false

    public var spacing: CGFloat = 12

    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 7)

}
