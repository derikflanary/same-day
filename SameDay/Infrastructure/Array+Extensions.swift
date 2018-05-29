//
//  Array+Extensions.swift
//  SameDay
//
//  Created by Derik Flanary on 5/24/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import Foundation

extension Array where Element: Equatable  {

    mutating func replace(item: Element) {
        if let index = index(of: item) {
            self[index] = item
        }
    }

    mutating func remove(item: Element) {
        if let index = index(of: item) {
            remove(at: index)
        }
    }

}

