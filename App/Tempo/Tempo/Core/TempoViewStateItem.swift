//
//  Copyright © 2015 Target. All rights reserved.
//

/// A type that represents a collection view item.
public protocol TempoViewStateItem: TempoIdentifiable, TempoFocusable {
    /// Check if this item is equal to another `TempoViewStateItem`.
    ///
    /// - Parameter other: The other item to check for equality.
    /// - Returns: Boolean indicating if the two items are equal.
    func isEqualTo(_ other: TempoViewStateItem) -> Bool
}

// MARK: Default implementations

public extension TempoViewStateItem where Self: Equatable {
    func isEqualTo(_ other: TempoViewStateItem) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

// MARK: Equality helper functions

public func areOptionalItemsEqual(_ lhs: TempoViewStateItem?, _ rhs: TempoViewStateItem?) -> Bool {
    switch (lhs, rhs) {
    case (.some(let leftItem), .some(let rightItem)):
        return leftItem.isEqualTo(rightItem)

    case (.none, .none):
        return true

    default:
        return false
    }
}

public func == (lhs: [TempoViewStateItem], rhs: [TempoViewStateItem]) -> Bool {
    lhs.count == rhs.count
        && zip(lhs, rhs).allSatisfy { $0.isEqualTo($1) }
}
