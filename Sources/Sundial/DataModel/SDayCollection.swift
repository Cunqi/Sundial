//
//  SDayCollection.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/30/24.
//

import Foundation

public protocol SDayCollection: Identifiable {

    var days: [SDay] { get set }

    var hasPrevious: Bool { get }

    var hasNext: Bool { get }

    var dateRange: ClosedRange<Date>? { get }

    var numOfLeadingDays: Int { get }
}
