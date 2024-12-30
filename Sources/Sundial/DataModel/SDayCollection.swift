//
//  SDayCollection.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/30/24.
//

import Foundation

protocol SDayCollection: Identifiable {

    var days: [SDay] { get }

    var hasPrevious: Bool { get }

    var hasNext: Bool { get }

    var dateRange: ClosedRange<Date>? { get }

    func updateDisabledDays(with dateRange: ClosedRange<Date>) -> Self
}
