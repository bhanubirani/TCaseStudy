//
//  CollectionViewAdapter+HarmonyLayoutDelegate.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

protocol HarmonyLayoutSection {
    var style: HarmonySectionStyle? { get }
    var margins: HarmonyLayoutMargins? { get }
    var hasHeader: Bool { get }
}

extension HarmonyLayoutSection {
    var style: HarmonySectionStyle? { return nil }
    var margins: HarmonyLayoutMargins? { return nil }
    var hasHeader: Bool { return false }
}

extension HarmonyLayoutSection where Self: TempoViewStateSection {
    var hasHeader: Bool {
        return header != nil
    }
}

protocol HarmonyLayoutItem {
    func height(for width: CGFloat) -> CGFloat?
    var margins: HarmonyLayoutMargins? { get }
    var separatorInsets: UIEdgeInsets? { get }
    var style: HarmonyCellStyle? { get }
    var tileSize: HarmonyTileSize? { get }
    var tileSpacing: CGFloat? { get }
    var tileInsets: UIEdgeInsets? { get }
    var padding: UIEdgeInsets? { get }
}

extension HarmonyLayoutItem {
    func height(for width: CGFloat) -> CGFloat? { return nil }
    var margins: HarmonyLayoutMargins? { return nil }
    var separatorInsets: UIEdgeInsets? { return nil }
    var style: HarmonyCellStyle? { return nil }
    var tileSize: HarmonyTileSize? { return nil }
    var tileSpacing: CGFloat? { return nil }
    var tileInsets: UIEdgeInsets? { return nil }
    var padding: UIEdgeInsets? { return nil }
}

extension CollectionViewAdapter: HarmonyLayoutDelegate {
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, heightForItemAtIndexPath indexPath: IndexPath, forWidth: CGFloat) -> CGFloat {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.height(for: forWidth) ?? harmonyLayout.defaultItemHeight
        }
        
        return harmonyLayoutComponentFor(indexPath)?
            .heightForLayout(harmonyLayout, item: itemFor(indexPath), width: forWidth) ?? harmonyLayout.defaultItemHeight
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, heightForHeaderInSection section: Int, for width: CGFloat) -> CGFloat {
        guard let header = sectionFor(section).header else {
            return harmonyLayout.defaultHeaderHeight
        }
        
        if let header = header as? HarmonyLayoutItem {
            return header.height(for: width) ?? harmonyLayout.defaultHeaderHeight
        }
        
        return harmonyLayoutComponent(forHeaderInSection: section)?
            .heightForLayout(harmonyLayout, item: header, width: width) ?? harmonyLayout.defaultHeaderHeight
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForSection section: Int) -> HarmonyLayoutMargins {
        if let section = sectionFor(section) as? HarmonyLayoutSection {
            return section.margins ?? harmonyLayout.defaultSectionMargins
        }
        
        let indexPath = IndexPath(item: 0, section: section)
        return harmonyLayoutComponentFor(indexPath)?
            .sectionMarginsForLayout(harmonyLayout) ?? harmonyLayout.defaultSectionMargins
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForItemAtIndexPath indexPath: IndexPath) -> HarmonyLayoutMargins {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.margins ?? harmonyLayout.defaultItemMargins
        }
        
        return harmonyLayoutComponentFor(indexPath)?
            .itemMarginsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultItemMargins
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, showHeaderForSection section: Int) -> Bool {
        guard let section = sectionFor(section) as? HarmonyLayoutSection else {
            return false
        }
        
        return section.hasHeader
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, styleForItemAtIndexPath indexPath: IndexPath) -> HarmonyCellStyle {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.style ?? harmonyLayout.defaultItemStyle
        }
        
        return harmonyLayoutComponentFor(indexPath)?
            .styleForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultItemStyle
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, separatorInsetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.separatorInsets ?? harmonyLayout.defaultSeparatorInsets
        }
        
        return harmonyLayoutComponentFor(indexPath)?
            .separatorInsetsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultSeparatorInsets
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, separatorHiddenForItemAtIndexPath indexPath: IndexPath) -> Bool {
        return harmonyLayoutComponentFor(indexPath)?
            .separatorHiddenForLayout(harmonyLayout, item: itemFor(indexPath)) ?? false
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, highlightStyleForItemAtIndexPath indexPath: IndexPath) -> HarmonyHighlightStyle {
        return harmonyLayoutComponentFor(indexPath)?
            .highlightStyleForLayout(harmonyLayout, item: itemFor(indexPath)) ?? .background
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileSizeForItemAtIndexPath indexPath: IndexPath) -> HarmonyTileSize {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.tileSize ?? harmonyLayout.defaultTileSize
        }
        
        return harmonyLayoutComponentFor(indexPath)?.tileSizeForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileSize
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileSpacingForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.tileSpacing ?? harmonyLayout.defaultTileSpacing
        }
        
        return harmonyLayoutComponentFor(indexPath)?.tileSpacingForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileSpacing
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileInsetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.tileInsets ?? harmonyLayout.defaultTileInsets
        }
        
        return harmonyLayoutComponentFor(indexPath)?.tileInsetsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileInsets
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, paddingForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets {
        if let item = itemFor(indexPath) as? HarmonyLayoutItem {
            return item.padding ?? harmonyLayout.defaultPadding
        }
        
        return harmonyLayoutComponentFor(indexPath)?.paddingForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultPadding
    }
    
    public func harmonyLayout(_ harmonyLayout: HarmonyLayout, styleForSection section: Int) -> HarmonySectionStyle {
        if let section = sectionFor(section) as? HarmonyLayoutSection {
            return section.style ?? harmonyLayout.defaultSectionStyle
        }
        
        let indexPath = IndexPath(item: 0, section: section)
        return harmonyLayoutComponentFor(indexPath)?.sectionStyleForLayout(harmonyLayout) ?? harmonyLayout.defaultSectionStyle
    }
    
    // MARK: Private
    
    fileprivate func harmonyLayoutComponentFor(_ indexPath: IndexPath) -> HarmonyLayoutComponent? {
        return componentFor(indexPath) as? HarmonyLayoutComponent
    }
    
    fileprivate func harmonyLayoutComponent(forHeaderInSection section: Int) -> HarmonyLayoutComponent? {
        let indexPath = IndexPath(item: 0, section: section)
        return componentFor(supplementaryViewAtIndexPath: indexPath).component as? HarmonyLayoutComponent
    }
}
