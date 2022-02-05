//
//  Copyright © 2015 Target. All rights reserved.
//

import Dispatch
import Foundation

public enum CollectionViewSectionUpdate: Equatable {
    case insert(Int)
    case delete(Int)
    case update(Int, Int, [CollectionViewItemUpdate])
    case focus(TempoFocus)
    case header(Int, Int)
}

public enum CollectionViewItemUpdate: Equatable {
    case insert(Int)
    case delete(Int)
    case update(Int, Int)
    case move(Int, Int)
}

public struct SectionPresenterEvent {
    public struct UpdatesApplied: EventType {
        public let animationCompleted: Bool
        
        public init(animationCompleted: Bool) {
            self.animationCompleted = animationCompleted
        }
    }
}

public protocol SectionPresenterAdapter: AnyObject {
    func applyUpdates(_ updates: [CollectionViewSectionUpdate], viewState: MemoizedTempoSectionedViewState, completion: ((_ animationCompleted: Bool) -> Void)?)
}

public enum SectionPresenterError: Error {
    case duplicateIdentifiers(SectionPresenterDuplicates)
}

public struct SectionPresenterDuplicates {
    public struct Dupe {
        public let type: String
        public let identifier: String
    }

    public let dupes: [Dupe]
    public let section: TempoViewStateSection?

    public init(dupes: [Dupe], section: TempoViewStateSection? = nil) {
        self.dupes = dupes
        self.section = section
    }

    public var message: String {
        var message = "The following TempoViewStateItem identifiers appear in the view state more than once. The diffing algorithm considers two items to be the same if they have the same identifier, so duplicates can cause the wrong number of updates to be applied to the collection view and result in a crash.\n\n"

        if let section = section {
            message.append("Section: \(type(of: section)), identifier: \(section.identifier)\n\n")
        }

        message.append("Identifiers:\n")
        message.append(dupes.map { "\($0.identifier) (\($0.type))" }.joined(separator: "\n"))
        return message
    }
}

public final class SectionPresenter: NSObject, TempoPresenter {
    public var dispatcher: Dispatcher?
    
    /// Specifies whether collection view updates happen asynchronously. Set to true if large data sets are causing scrolling performance issues
    public var asyncUpdates = false
    
    fileprivate var viewState: MemoizedTempoSectionedViewState?
    fileprivate let adapter: SectionPresenterAdapter
    fileprivate static let serialQueue = DispatchQueue(label: "com.target.tempo.sectionPresenter")
    
    public init(adapter: SectionPresenterAdapter) {
        self.adapter = adapter
    }
    
    public func present(_ viewState: TempoSectionedViewState) {
        let memoizedViewState = MemoizedTempoSectionedViewState(viewState: viewState)
        
        guard let fromViewState = self.viewState else {
            self.viewState = memoizedViewState
            adapter.applyUpdates([], viewState: memoizedViewState) { [weak dispatcher] completed in
                dispatcher?.triggerEvent(SectionPresenterEvent.UpdatesApplied(animationCompleted: completed))
            }
            return
        }
        
        self.viewState = memoizedViewState

        if !asyncUpdates {
            let updates = updatesFrom(fromViewState, toViewState: memoizedViewState)
            adapter.applyUpdates(updates, viewState: memoizedViewState) { [weak dispatcher] completed in
                dispatcher?.triggerEvent(SectionPresenterEvent.UpdatesApplied(animationCompleted: completed))
            }
        } else {
            SectionPresenter.serialQueue.async { [weak self] in
                guard let updates = self?.updatesFrom(fromViewState, toViewState: memoizedViewState) else {
                    return
                }
                
                DispatchQueue.main.async { [weak adapter = self?.adapter, weak dispatcher = self?.dispatcher] in
                    guard let adapter = adapter else {
                        return
                    }
                    
                    adapter.applyUpdates(updates, viewState: memoizedViewState) { completed in
                        dispatcher?.triggerEvent(SectionPresenterEvent.UpdatesApplied(animationCompleted: completed))
                    }
                }
            }
        }
    }

    func updatesFrom(_ fromViewState: MemoizedTempoSectionedViewState, toViewState: MemoizedTempoSectionedViewState) -> [CollectionViewSectionUpdate] {
        let updates: [CollectionViewSectionUpdate]

        do {
            updates = try SectionPresenter.updatesFrom(fromViewState, toViewState: toViewState)
        } catch SectionPresenterError.duplicateIdentifiers(let duplicates) {
            // The collection view is going to crash. Crash now with a better error.
            fatalError(duplicates.message)
        } catch {
            assertionFailure(error.localizedDescription)
            updates = []
        }

        return updates
    }

    fileprivate static func updatesFrom(_ fromViewState: TempoSectionedViewState, toViewState: TempoSectionedViewState) throws -> [CollectionViewSectionUpdate] {
        try detectDuplicateIdentifiers(items: toViewState.sections)
        var updates = [CollectionViewSectionUpdate]()
        
        let previousSections = fromViewState.sections
        let updatedSections = toViewState.sections
        
        for (index, updated) in updatedSections.enumerated() {
            if !previousSections.contains(where: { $0.identifier == updated.identifier }) {
                updates.append(.insert(index))
            }
        }
        
        for (fromIndex, previous) in previousSections.enumerated() {
            if let (toIndex, updated) = updatedSections.enumerated().first(where: { $0.element.identifier == previous.identifier }) {
                if !updated.isEqualTo(previous) {
                    let previousItems = previous.items
                    let updatedItems = updated.items

                    try detectDuplicateIdentifiers(items: updatedItems, section: updated)
                    let itemUpdates = updatesFrom(previousItems, toItems: updatedItems)
                    updates.append(.update(fromIndex, toIndex, itemUpdates))
                }

                // Supplementary view insertion/removal are handled by `UICollectionViewLayout`
                if let previousHeader = previous.header, let updatedHeader = updated.header, !previousHeader.isEqualTo(updatedHeader) {
                    updates.append(.header(fromIndex, toIndex))
                }
            } else {
                updates.append(.delete(fromIndex))
            }
        }
        
        if let focus = toViewState.focus {
            updates.append(.focus(focus))
        }
        
        return updates
    }
    
    fileprivate static func updatesFrom(_ fromItems: [TempoViewStateItem], toItems: [TempoViewStateItem]) -> [CollectionViewItemUpdate] {
        var updates: [CollectionViewItemUpdate] = []
        
        for (index, updated) in toItems.enumerated() {
            if !fromItems.contains(where: { $0.identifier == updated.identifier }) {
                updates.append(.insert(index))
            }
        }
        
        for (fromIndex, previous) in fromItems.enumerated() {
            if let (toIndex, updated) = toItems.enumerated().first(where: { $0.element.identifier == previous.identifier }) {
                if !updated.isEqualTo(previous) {
                    updates.append(.update(fromIndex, toIndex))
                }
                
                if fromIndex != toIndex {
                    updates.append(.move(fromIndex, toIndex))
                }
            } else {
                updates.append(.delete(fromIndex))
            }
        }
        
        return updates
    }

    fileprivate static func detectDuplicateIdentifiers(items: [TempoIdentifiable], section: TempoViewStateSection? = nil) throws {
        let unique = Set(items.map(\.identifier))

        guard unique.count < items.count else {
            // No duplicates found.
            return
        }

        let candidates = items.reduce(into: [String: [SectionPresenterDuplicates.Dupe]]()) {
            let dupe = SectionPresenterDuplicates.Dupe(type: "\(type(of: $1))", identifier: $1.identifier)
            $0[$1.identifier, default: []].append(dupe)
        }

        let dupes = candidates.filter { $0.value.count > 1 }.flatMap(\.value)
        let duplicates = SectionPresenterDuplicates(dupes: dupes, section: section)
        throw SectionPresenterError.duplicateIdentifiers(duplicates)
    }
}
