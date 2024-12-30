//
//  SWeekday.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/29/24.
//

import Foundation

public struct SDay: Identifiable {
    public let id = UUID()

    public var date: Date

    public var isDisabled = false
}
