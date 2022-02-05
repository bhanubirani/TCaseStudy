//
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation
import UIKit

open class CollectionViewAdapter: NSObject {
    public weak var scrollViewDelegate: UIScrollViewDelegate?
    
    fileprivate let collectionView: UICollectionView
    fileprivate let componentProvider: ComponentProvider
    fileprivate var viewState = MemoizedTempoSectionedViewState(viewState: InitialViewState())
    fileprivate var focusingIndexPath: IndexPath?
    fileprivate let reusableViewContainer: ReusableViewContainer
    
    fileprivate struct InitialViewState: TempoSectionedViewState {
        var sections: [TempoViewStateSection] { [] }
    }
    
    private let alwaysApplyNonemptyUpdates: Bool

    // MARK: Init
    
    /// Initializes a CollectionViewAdapter
    ///
    /// - Parameters:
    ///   - collectionView: the collectionView that is being adapted to work with viewStates and components.
    ///   - componentProvider: the componentProvider that returns a component based on a viewState.
    ///   - reusableViewContainerType: the type of the ReusableViewContainer to use for managing reusable views.
    public init(
        collectionView: UICollectionView,
        componentProvider: ComponentProvider,
        reusableViewContainerType: ReusableViewContainer.Type = ReusableCollectionViewContainer.self,
        alwaysApplyNonemptyUpdates: Bool = false
    ) {
        self.collectionView = collectionView
        self.componentProvider = componentProvider
        self.reusableViewContainer = reusableViewContainerType.init(collectionView: collectionView)
        self.alwaysApplyNonemptyUpdates = alwaysApplyNonemptyUpdates
        super.init()
        
        componentProvider.registerComponents(reusableViewContainer)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: Public Methods
    
    public func itemFor(_ indexPath: IndexPath) -> TempoViewStateItem {
        viewState.item(for: indexPath)
    }
    
    public func supplementaryItemFor(_ indexPath: IndexPath) -> TempoViewStateItem {
        viewState.supplementaryItem(for: indexPath)
    }
    
    public func sectionFor(_ section: Int) -> TempoViewStateSection {
        viewState.sections[section]
    }
    
    public func componentFor(_ indexPath: IndexPath) -> ComponentType {
        let item = itemFor(indexPath)
        return componentProvider.componentFor(item)
    }
    
    public func componentFor(supplementaryViewAtIndexPath indexPath: IndexPath) -> SupplementaryComponent {
        let supplementaryItem = supplementaryItemFor(indexPath)
        return componentProvider.supplementaryComponentFor(supplementaryItem)
    }
    
    // MARK: Private Methods
    
    fileprivate func insertSection(_ section: Int) {
        collectionView.insertSections(IndexSet(integer: section))
    }
    
    fileprivate func deleteSection(_ section: Int) {
        collectionView.deleteSections(IndexSet(integer: section))
    }
    
    fileprivate func updateSection(_ fromSection: Int, fromViewState: MemoizedTempoSectionedViewState, toSection: Int) {
        for item in 0 ..< fromViewState.numberOfItems(inSection: fromSection) {
            let fromIndexPath = IndexPath(item: item, section: fromSection)
            let toIndexPath = IndexPath(item: item, section: toSection)
            itemInfoForIndexPath(fromIndexPath, toIndexPath: toIndexPath).configureView()
        }
    }
    
    fileprivate func updateSection(_ fromSection: Int, toSection: Int, itemUpdates: [CollectionViewItemUpdate]) {
        for update in itemUpdates {
            switch update {
            case .delete(let item):
                collectionView.deleteItems(at: [IndexPath(item: item, section: fromSection)])
                
            case .insert(let item):
                collectionView.insertItems(at: [IndexPath(item: item, section: toSection)])
                
            case .update(let fromItem, let toItem):
                let fromIndexPath = IndexPath(item: fromItem, section: fromSection)
                let toIndexPath = IndexPath(item: toItem, section: toSection)
                itemInfoForIndexPath(fromIndexPath, toIndexPath: toIndexPath).configureView()

            case .move(let fromItem, let toItem):
                let fromIndexPath = IndexPath(item: fromItem, section: fromSection)
                let toIndexPath = IndexPath(item: toItem, section: toSection)
                collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
            }
        }
    }
    
    fileprivate func focus(_ focus: TempoFocus) {
        guard focus.indexPath != focusingIndexPath else { // Scroll already in progress
            return
        }
        
        guard let attributes = collectionView.layoutAttributesForItem(at: focus.indexPath) else {
            return
        }
        
        let scrollPosition: UICollectionView.ScrollPosition
        
        switch focus.position {
        case .centeredHorizontally:
            scrollPosition = .centeredHorizontally
            
        case .centeredVertically:
            scrollPosition = .centeredVertically
        }
        
        if collectionView.bounds.inset(by: collectionView.contentInset).contains(attributes.frame) {
            // The item is already fully visible.
            didFocus(focus.indexPath, attributes: attributes)
        } else if focus.animated {
            // Track index path during animation. Reset in `scrollViewDidEndScrollingAnimation:`.
            focusingIndexPath = focus.indexPath
            collectionView.scrollToItem(at: focus.indexPath, at: scrollPosition, animated: true)
        } else {
            collectionView.scrollToItem(at: focus.indexPath, at: scrollPosition, animated: false)
            didFocus(focus.indexPath, attributes: attributes)
        }
    }
    
    fileprivate func updateHeader(_ fromSection: Int, toSection: Int) {
        let fromIndexPath = IndexPath(item: 0, section: fromSection)
        let toIndexPath = IndexPath(item: 0, section: toSection)
        supplementaryInfo(fromIndexPath, toIndexPath: toIndexPath).configureView()
    }
    
    fileprivate func itemInfoForIndexPath(_ indexPath: IndexPath) -> CollectionViewItemInfo {
        itemInfoForIndexPath(indexPath, toIndexPath: indexPath)
    }
    
    fileprivate func itemInfoForIndexPath(_ fromIndexPath: IndexPath, toIndexPath: IndexPath) -> CollectionViewItemInfo {
        let toViewState = viewState.item(for: toIndexPath)
        let component = componentProvider.componentFor(toViewState)
        let container = reusableViewContainer.reusableViewItemContainer(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath)
        
        return CollectionViewItemInfo(
            viewState: toViewState,
            component: component,
            container: container
        )
    }
    
    fileprivate func supplementaryInfo(for indexPath: IndexPath) -> CollectionViewSupplementaryInfo {
        supplementaryInfo(indexPath, toIndexPath: indexPath)
    }
    
    fileprivate func supplementaryInfo(_ fromIndexPath: IndexPath, toIndexPath: IndexPath) -> CollectionViewSupplementaryInfo {
        let toViewState = viewState.supplementaryItem(for: toIndexPath)
        let container = reusableViewContainer.reusableViewItemContainer(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath)
        
        let supplementaryComponent = componentProvider.supplementaryComponentFor(toViewState)
        
        return CollectionViewSupplementaryInfo(
            viewState: toViewState,
            supplementaryComponent: supplementaryComponent,
            container: container
        )
    }
    
    fileprivate func didFocus(_ indexPath: IndexPath, attributes: UICollectionViewLayoutAttributes) {
        let itemInfo = itemInfoForIndexPath(indexPath)
        itemInfo.focusAccessibility()
        itemInfo.didFocus(attributes.frame, coordinateSpace: collectionView)
    }
}

// MARK: - SectionPresenterAdapter

extension CollectionViewAdapter: SectionPresenterAdapter {
    public func applyUpdates(_ updates: [CollectionViewSectionUpdate], viewState: MemoizedTempoSectionedViewState, completion: ((_ animationCompleted: Bool) -> Void)? = nil) {
        // Bail if there aren't any updates to apply.
        guard !updates.isEmpty else {
            self.viewState = viewState
            completion?(true)
            return
        }

        if !alwaysApplyNonemptyUpdates {
            // Bail unless the collection view has already been laid out. Since the collection view's
            // internal cache is updated when it's laid out, calling `performBatchUpdates` with deletes
            // or inserts before layout crashes with `NSInternalInconsistencyException`.
            guard collectionView.contentSize != .zero else {
                self.viewState = viewState
                completion?(false)
                return
            }
        }

        collectionView.performBatchUpdates({
            // according to UICV docs, datasource updates should occur within this block
            // see 'A Tour of UICollectionView' WWDC 2018 - Session 225 for more info
            // https://developer.apple.com/videos/play/wwdc2018/225/
            let fromViewState = self.viewState
            self.viewState = viewState

            for update in updates {
                switch update {
                case .delete(let index):
                    self.deleteSection(index)
                case .insert(let index):
                    self.insertSection(index)
                case .update(let fromIndex, let toIndex, let itemUpdates):
                    if !itemUpdates.isEmpty {
                        self.updateSection(fromIndex, toSection: toIndex, itemUpdates: itemUpdates)
                    } else {
                        self.updateSection(fromIndex, fromViewState: fromViewState, toSection: toIndex)
                    }
                case .focus(let focus):
                    // Post-update focus handled in the batch completion below.
                    guard focus.focusBehavior == .inUpdate else { return }
                    self.focus(focus)
                case .header(let fromIndex, let toIndex):
                    self.updateHeader(fromIndex, toSection: toIndex)
                }
            }
        }) { [weak self] updated in
            defer {
                completion?(updated)
            }
            
            guard updated else { return }
            
            // Post batch updates we only support .focus operations that have a special .postUpdate behavior.
            for update in updates {
                switch update {
                case .focus(let focus) where focus.focusBehavior == .postUpdate:
                    self?.focus(focus)
                default: break
                }
            }
        }
    }
}

// MARK: - ComponentWrapper

public struct ComponentWrapper {
    public init(cell: UICollectionViewCell, view: UIView) {
        self.cell = cell
        self.view = view
    }
    
    var cell: UICollectionViewCell
    var view: UIView
}

// MARK: - CollectionViewItemInfo

private struct CollectionViewItemInfo {
    let viewState: TempoViewStateItem
    let component: ComponentType
    let container: ReusableViewItemContainer
    
    var view: UIView? {
        component.visibleWrapper(container)?.view
    }
    
    func buildCell() -> UICollectionViewCell {
        let wrapper = component.dequeueWrapper(container)
        component.prepareView(wrapper.view, viewState: viewState)
        component.configureView(wrapper.view, viewState: viewState)
        return wrapper.cell
    }
    
    func configureView() {
        if let view = view {
            component.configureView(view, viewState: viewState)
        }
    }
    
    func focusAccessibility() {
        if let view = view {
            component.focusAccessibility(view, viewState: viewState)
        }
    }
    
    func shouldHighlightView() -> Bool {
        if let view = view {
            return component.shouldHighlightView(view, viewState: viewState)
        } else {
            return shouldSelectView()
        }
    }
    
    func shouldSelectView() -> Bool {
        if let view = view {
            return component.shouldSelectView(view, viewState: viewState)
        } else {
            return true
        }
    }
    
    func selectView() {
        if let view = view, shouldSelectView() {
            component.selectView(view, viewState: viewState)
        }
    }
    
    func didFocus(_ frame: CGRect, coordinateSpace: UICoordinateSpace) {
        component.didFocus(frame, coordinateSpace: coordinateSpace, viewState: viewState)
    }
}

// MARK: - CollectionViewSupplementaryInfo

private struct CollectionViewSupplementaryInfo {
    let viewState: TempoViewStateItem
    let component: ComponentType
    let kind: String
    let container: ReusableViewItemContainer
    
    init(viewState: TempoViewStateItem, supplementaryComponent: SupplementaryComponent, container: ReusableViewItemContainer) {
        self.viewState = viewState
        self.component = supplementaryComponent.component
        self.kind = supplementaryComponent.kind
        self.container = container
    }
    
    var view: UIView? {
        component.visibleWrapper(container, forSupplementaryViewOfKind: kind)?.view
    }
    
    func buildSupplementaryView() -> UICollectionReusableView {
        let wrapper = component.dequeueWrapper(container, forSupplementaryViewOfKind: kind)
        component.prepareView(wrapper.view, viewState: viewState)
        component.configureView(wrapper.view, viewState: viewState)
        return wrapper.cell
    }
    
    func configureView() {
        if let view = view {
            component.configureView(view, viewState: viewState)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewAdapter: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewState.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewState.numberOfItems(inSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        itemInfoForIndexPath(indexPath).buildCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        supplementaryInfo(for: indexPath).buildSupplementaryView()
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewAdapter: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemInfoForIndexPath(indexPath).selectView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        itemInfoForIndexPath(indexPath).shouldHighlightView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        itemInfoForIndexPath(indexPath).shouldSelectView()
    }
}

// MARK: - UIScrollViewDelegate

extension CollectionViewAdapter: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = focusingIndexPath {
            focusingIndexPath = nil
            
            if let attributes = collectionView.layoutAttributesForItem(at: indexPath) {
                didFocus(indexPath, attributes: attributes)
            }
        }
        
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        scrollViewDelegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
