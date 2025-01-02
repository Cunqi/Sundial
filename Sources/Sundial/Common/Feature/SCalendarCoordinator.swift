//
//  SCalendarCoordinator.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/31/24.
//

import SwiftUI

@Observable public class SCalendarCoordinator {

    public var calendar: Calendar = .current

    public var locale: Locale = .current

    public var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}
