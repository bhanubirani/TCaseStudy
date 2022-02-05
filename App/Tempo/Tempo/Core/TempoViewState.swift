//
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation
import UIKit

public protocol TempoViewState {}

public protocol TempoSectionedViewState {
    var sections: [TempoViewStateSection] { get }
    var focus: TempoFocus? { get }
}

public extension TempoSectionedViewState {
    var focus: TempoFocus? {
        nil
    }
}

// MARK: - MemoizedTempoSectionedViewState

/// A simplified copy of a `TempoSectionedViewState`, optimized for access to the
/// original view state's sections and the items in each section.
///
/// Using a `MemoizedTempoSectionedViewState` instead of the original view state helps
/// reduce the cost of accessing the `sections` and `items` arrays on the view states.
///
/// These arrays are often implemented as computed properties, which means allocating,
/// deallocating, and force casting the array(s) with each access. In a tight loop, as seen in
/// `CollectionViewAdapter`, this adds up to a noticeable performance issue. This memoized
/// version of the view state accesses the sections/items once, pulling them out for future use
/// through `item(for:)` and `supplementaryItem(for:)` functions.
///
/// - Note: This struct should typically not be used outside Tempo itself.
public struct MemoizedTempoSectionedViewState: TempoViewState, TempoSectionedViewState {
    public let sections: [TempoViewStateSection]
    public let sectionItems: [[TempoViewStateItem]]
    public let focus: TempoFocus?

    public init(viewState: TempoSectionedViewState) {
        self.sections = viewState.sections
        self.sectionItems = sections.map(\.items)
        self.focus = viewState.focus
    }
    
    public func numberOfItems(inSection sectionIndex: Int) -> Int {
        sectionItems[sectionIndex].count
    }
    
    public func item(for indexPath: IndexPath) -> TempoViewStateItem {
        sectionItems[indexPath.section][indexPath.item]
    }
    
    public func supplementaryItem(for indexPath: IndexPath) -> TempoViewStateItem {
        guard let header = sections[indexPath.section].header else {
            fatalError("No view state for supplementary view at index path \(indexPath)")
        }
        
        return header
    }
}
