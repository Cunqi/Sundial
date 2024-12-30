//
//  File.swift
//  Sundial
//
//  Created by Cunqi Xiao on 12/30/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index?) -> Element? {
        guard let index, indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
