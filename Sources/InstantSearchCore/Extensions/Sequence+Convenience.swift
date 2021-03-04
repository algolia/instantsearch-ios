//
//  Sequence+Convenience.swift
//  
//
//  Created by Vladislav Fitc on 19/02/2021.
//

import Foundation

public extension Sequence {

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { leftElement, rightElement in
            return leftElement[keyPath: keyPath] < rightElement[keyPath: keyPath]
        }
    }

}
