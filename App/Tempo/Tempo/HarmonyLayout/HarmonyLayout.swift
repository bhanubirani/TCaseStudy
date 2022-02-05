//
//  HarmonyLayout.swift
//  Harmony
//
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
*  Harmony-styled collection view layout. Designed to handle all of the cell styles defined for the
*  Target app.
*/
public class HarmonyLayout: UICollectionViewLayout {
    static let backdropViewKind = "backdrop"
    static let headerViewKind = "header"
    
    // MARK: - Internal Properties
    
    /// Indicates whether or not to collapse the first section's top margin. Default is true.
    public var collapseFirstSectionTopMargin = true
    
    /// Indicates whether or not to collapse the last section's bottom margin. Default is true.
    public var collapseLastSectionBottomMargin = true
    
    /// Margins that surround the entire collection view.
    public var collectionViewMargins = HarmonyLayoutMargins(top: .narrow, right: .none, bottom: .narrow, left: .none)
    
    /// Default section margins.
    public var defaultSectionMargins = HarmonyLayoutMargins(top: .none, right: .none, bottom: .wide, left: .none)
    
    /// Default section header margins.
    public var defaultHeaderMargins = HarmonyLayoutMargins(top: .none, right: .narrow, bottom: .none, left: .narrow)
    
    // Default height for section headers.
    public var defaultHeaderHeight: CGFloat = 21.0
    
    /// Default item margins.
    public var defaultItemMargins = HarmonyLayoutMargins(top: .none, right: .narrow, bottom: .none, left: .narrow)
    
    /// Default item height.
    public var defaultItemHeight: CGFloat = 44.0
    
    /// Default item style. Used when the delegate does not specify item style.
    public var defaultItemStyle: HarmonyCellStyle = .grouped
    
    /// Default sections style. Used when the delegate does not specify section style.
    public var defaultSectionStyle: HarmonySectionStyle = .list
    
    /// Default separator insets. Used when the delegate does not specify separator insets.
    public var defaultSeparatorInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    /// Default highlight style. Used when the delegate does not specify highlight style
    public var defaultHighlightStyle: HarmonyHighlightStyle = .background
    
    /// Default tile size. Used when the delegate does not specify tile size.
    public var defaultTileSize: HarmonyTileSize = .wide
    
    /// Default tile insets. Used when the delegate does not specify tile insets.
    public var defaultTileInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    
    // Default tile margins. Used when the delegate does not specify tile margins.
    public var defaultPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    // Default tile spacing. Used when the delegate does not specify tile spacing.
    public var defaultTileSpacing: CGFloat = 0
    
    // A Boolean value indicating whether a backdrop appears behind the collection view's content.
    public var displaysBackdrop = false
    
    // MARK: - Private Properties
    
    fileprivate var cachedContentSize = CGSize.zero
    fileprivate var currentAttributes: [IndexPath: HarmonyCellAttributes] = [:]
    fileprivate var sectionHeaderAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    // The backdrop appears behind all the views displayed for the collection view's items.
    fileprivate var backdropAttributes: UICollectionViewLayoutAttributes?
    
    fileprivate weak var _harmonyLayoutDelegate: HarmonyLayoutDelegate? = nil
    
    // MARK: - Lifecycle methods
    
    public override init() {
        super.init()
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        register(HarmonyBackdropView.self, forDecorationViewOfKind: HarmonyLayout.backdropViewKind)
    }
}

class HarmonyBackdropView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        backgroundColor = .targetFadeAwayGrayColor
        
        // A dirty hack to fix an apparent bug with collection views not respecting zIndex.
        superview?.sendSubviewToBack(self)
    }
}

// MARK: - UICollectionViewLayout

public extension HarmonyLayout {
    var contentSizeWidth: CGFloat {
        return collectionView?.bounds.size.width ?? 0.0
    }
    
    var harmonyLayoutDelegate: HarmonyLayoutDelegate? {
        if _harmonyLayoutDelegate == nil {
            _harmonyLayoutDelegate = collectionView?.delegate as? HarmonyLayoutDelegate
        }
        return _harmonyLayoutDelegate
    }
    
    func tileSize(forIndexPath indexPath: IndexPath) -> HarmonyTileSize {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileSizeForItemAtIndexPath: indexPath) ?? defaultTileSize
    }
    
    func tileInsets(forIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileInsetsForItemAtIndexPath: indexPath) ?? defaultTileInsets
    }
    
    func tileSpacing(forIndexPath indexPath: IndexPath) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileSpacingForItemAtIndexPath: indexPath) ?? defaultTileSpacing
    }
    
    func padding(forIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, paddingForItemAtIndexPath: indexPath) ?? defaultPadding
    }
    
    func style(forSection section: Int) -> HarmonySectionStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, styleForSection: section) ?? defaultSectionStyle
    }
    
    func hasBreak(atIndexPath indexPath: IndexPath) -> Bool {
        return harmonyLayoutDelegate?.harmonyLayout?(self, breakAtIndexPath: indexPath) ?? false
    }
    
    func hasHeader(forSection section: Int) -> Bool {
        return harmonyLayoutDelegate?.harmonyLayout?(self, showHeaderForSection: section) ?? false
    }
    
    func margins(forSection section: Int) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForSection: section) ?? defaultSectionMargins
    }
    
    func margins(forHeaderInSection section: Int) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForHeaderInSection: section) ?? defaultHeaderMargins
    }
    
    func margins(forItemAtIndexPath indexPath: IndexPath) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForItemAtIndexPath: indexPath) ?? defaultItemMargins
    }
    
    func style(forItemAtIndexPath indexPath: IndexPath) -> HarmonyCellStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, styleForItemAtIndexPath: indexPath) ?? defaultItemStyle
    }
    
    func separatorInsets(forItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, separatorInsetsForItemAtIndexPath: indexPath) ?? defaultSeparatorInsets
    }
    
    func separatorHidden(forItemAtIndexPath indexPath: IndexPath) -> Bool {
        return harmonyLayoutDelegate?.harmonyLayout?(self, separatorHiddenForItemAtIndexPath: indexPath) ?? false
    }
    
    func higlightStyle(forItemAtIndexPath indexPath: IndexPath) -> HarmonyHighlightStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, highlightStyleForItemAtIndexPath: indexPath) ?? defaultHighlightStyle
    }
    
    func height(forHeaderInSection section: Int, width: CGFloat) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, heightForHeaderInSection: section, for: width) ?? defaultHeaderHeight
    }
    
    func height(forItemAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, heightForItemAtIndexPath: indexPath, forWidth:width) ?? defaultItemHeight
    }
    
    func width(forSection section: Int) -> CGFloat {
        let sectionMargins = margins(forSection: section)
        
        return contentSizeWidth - sectionMargins.left.points - sectionMargins.right.points - collectionViewMargins.left.points - collectionViewMargins.right.points
    }
    
    func width(forItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let itemMargins = margins(forItemAtIndexPath: indexPath)
        
        return width(forSection: indexPath.section) - itemMargins.left.points - itemMargins.right.points
    }
    
    func groupFramesForSection(_ section: Int) -> [CGRect]? {
        return currentAttributes.filter { $0.0.section == section } // Grab the attributes for the specified section
            .sorted(by: {left, right in left.0.item < right.0.item })
            .reduce([CGRect]()) { (groupFrames, currentFrame) in // Combine touching items into grouped frames.
                var mutableGroupFrames = groupFrames
                
                if let lastTest = mutableGroupFrames.last, lastTest.maxY == currentFrame.1.frame.minY,
                    let last = mutableGroupFrames.popLast() {
                    mutableGroupFrames.append(last.union(currentFrame.1.frame))
                } else {
                    mutableGroupFrames.append(currentFrame.1.frame)
                }
                return mutableGroupFrames
        }
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView,
            collectionView.numberOfSections == collectionView.dataSource?.numberOfSections?(in: collectionView) else {
                // Cache difference between collection view and data source. Maintain existing layout.
                return
        }
        
        sectionHeaderAttributes.removeAll(keepingCapacity: true)
        currentAttributes.removeAll(keepingCapacity: true)
        backdropAttributes = nil
        
        let contentSizeWidth = collectionView.bounds.size.width
        let contentSizeHeight = collectionView.bounds.size.height
        var y = collectionViewMargins.top.points
        
        let sectionCount = collectionView.numberOfSections
        
        for sectionIndex in 0..<sectionCount {
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            
            guard itemCount > 0 else { continue }
            
            guard itemCount == collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: sectionIndex) else {
                // Cache difference between collection view and data source. Maintain existing layout.
                return
            }
            
            let sectionMargins = margins(forSection: sectionIndex)
            
            let isFirstSection = sectionIndex == 0
            if !isFirstSection || !collapseFirstSectionTopMargin {
                let topMargin = sectionMargins.top.points
                y += topMargin
            }
            
            if hasHeader(forSection: sectionIndex) {
                let indexPath = IndexPath(item: 0, section: sectionIndex)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: HarmonyLayout.headerViewKind, with: indexPath)
                let headerMargins = margins(forHeaderInSection: indexPath.section)
                y += headerMargins.top.points
                let headerWidth = contentSizeWidth - headerMargins.left.points - headerMargins.right.points
                let headerHeight = height(forHeaderInSection: indexPath.section, width: headerWidth)
                let x = headerMargins.left.points
                attributes.frame = CGRect(x: x, y: y, width: headerWidth, height: headerHeight)
                sectionHeaderAttributes[indexPath] = attributes
                y += headerHeight + headerMargins.bottom.points
            }
            
            var maxY: CGFloat = 0
            
            let x = sectionMargins.left.points + collectionViewMargins.left.points
            
            let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: sectionIndex) }
            let sectionAttributes = HarmonyLayoutSectionAttributes(indexPaths: indexPaths, layout: self, style: style(forSection: sectionIndex)).offsetBy(dx: x, dy: y)
            
            for attributes in sectionAttributes {
                currentAttributes[attributes.indexPath] = attributes
                maxY = attributes.frame.maxY
            }
            
            y = maxY
            
            let isLastSection = sectionIndex == sectionCount - 1
            // Only execute this if at least one item was in the section. Otherwise, it shouldn't
            // "count" against the next margin.
            if itemCount > 0 && (!isLastSection || !collapseLastSectionBottomMargin) {
                let bottomMargin = sectionMargins.bottom.points
                y += bottomMargin
            }
        }
        
        y += collectionViewMargins.bottom.points
        cachedContentSize = CGSize(width: contentSizeWidth, height: y)
        
        if displaysBackdrop && currentAttributes.count > 0 {
            backdropAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: HarmonyLayout.backdropViewKind, with: IndexPath(item: 0, section: 0))
            backdropAttributes?.frame = CGRect(x: 0, y: 0, width: cachedContentSize.width, height: cachedContentSize.height + contentSizeHeight)
            backdropAttributes?.zIndex = -1
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return cachedContentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var intersection = [UICollectionViewLayoutAttributes]()
        
        for attributes in currentAttributes.values {
            if attributes.frame.intersects(rect) {
                intersection.append(attributes)
            }
        }
        
        for attributes in sectionHeaderAttributes.values {
            if attributes.frame.intersects(rect) {
                intersection.append(attributes)
            }
        }
        
        if let backdropAttributes = backdropAttributes, backdropAttributes.frame.intersects(rect) {
            intersection.append(backdropAttributes)
        }
        
        return intersection
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        currentAttributes = [:]
        sectionHeaderAttributes = [:]
        backdropAttributes = nil
        cachedContentSize = CGSize.zero
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[indexPath]
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return backdropAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sectionHeaderAttributes[indexPath]
    }
    
    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return backdropAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds ?? CGRect.zero
        let sizeChanged = !oldBounds.size.equalTo(newBounds.size)
        
        return sizeChanged
    }
}
