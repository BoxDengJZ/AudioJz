//
//  Util.swift
//  toPlay
//
//  Created by Jz D on 2020/12/15.
//

import Foundation



/// Anything that can hold a value (strings, arrays, etc)
public protocol Occupiable {
    /// Contains elements
    var isEmpty: Bool { get }
    /// Contains no elements
    var isNotEmpty: Bool { get }
}

// Give a default implementation of isNotEmpty, so conformance only requires one implementation
extension Occupiable {
    /// Contains no elements
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String: Occupiable {}

// I can't think of a way to combine these collection types. Suggestions welcome.
extension Array: Occupiable {}




extension ClosedRange {
    /// Clamp value to the range
    /// - parameter value: Value to clamp
    public func clamp(_ value: Bound) -> Bound {
        return Swift.min(Swift.max(value, lowerBound), upperBound)
    }
}
