//
//  SCalendarMetadata.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/28/24.
//

import SwiftUI

@Observable public class SCalendarMetadata {

    public var weekdaySymbols: [String] = SDateHelper.formatter.veryShortWeekdaySymbols

    public var itemFont: Font = .body

    public var weekdayColor: Color = .secondary

}
