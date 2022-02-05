//
//  Copyright © 2016 Target. All rights reserved.
//

/// A type that represents a collection view section.
public protocol TempoViewStateSection: TempoIdentifiable, TempoFocusable {
    /// Optional header item to be displayed at the top of the section.
    ///
    /// Ensure that the associated `Component` is registered as a `SupplementaryComponent` with
    /// `ComponentProvider`.
    var header: TempoViewStateItem? { get }

    /// The array of items to display in the section.
    ///
    /// Do not return an empty array for the property. Instead avoid returning the section at all if
    /// it has no content.
    var items: [TempoViewStateItem] { get }
    
    /// Check if two `TempoViewStateSection`s are equal.
    ///
    /// There are two default implementations provided. If the section can easily be conformed to
    /// `Equatable` that implementation will likely be faster.
    ///
    /// - Parameter other: The section to compare equality against.
    /// - Returns: Boolean indicating if this section is equal to `other`.
    func isEqualTo(_ other: TempoViewStateSection) -> Bool
}

// MARK: Default implementations

public extension TempoViewStateSection {
    var header: TempoViewStateItem? { nil }
    
    func isEqualTo(_ other: TempoViewStateSection) -> Bool {
        guard let other = other as? Self else { return false }
        return areOptionalItemsEqual(header, other.header)
            && items == other.items
    }
}

// Many sections compute the `items` array based on internal state. If the section is `Equatable`
// it's likely faster to compare that internal state instead of looping through the `items` array.
public extension TempoViewStateSection where Self: Equatable {
    func isEqualTo(_ other: TempoViewStateSection) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}
