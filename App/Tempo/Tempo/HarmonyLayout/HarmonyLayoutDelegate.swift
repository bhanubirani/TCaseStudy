//
//  HarmonyLayoutDelegate.swift
//  Harmony
//
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
*  Allows a collection view delegate to customize the attributes of sections and items.
*/
@objc
public protocol HarmonyLayoutDelegate: UICollectionViewDelegate {
    /**
    Asks the delegate for the height of the specified item. If this function isn't specified, then
    the layout's defaultItemHeight property is used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path of the item.
    - Parameter width:         The width of the item header.
    
    - Returns: The height of the specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, heightForItemAtIndexPath indexPath: IndexPath, forWidth: CGFloat) -> CGFloat
    
    /**
    Asks the delegate for the height of the specified section header. If this function isn't
    specified, then the layout's defaultHeaderHeight property is used instead. This method won't
    be invoked unless `showHeaderForSection` returns `true`.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter section:       The section index of the header.
    - Parameter width:         The width of the section header.
    
    - Returns: The height of the specified section header.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, heightForHeaderInSection section: Int, for width: CGFloat) -> CGFloat
    
    /**
    Asks the delegate for the margins for the specified section. If this function isn't specified,
    then the layout's defaultSectionMargins are used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter section:       The section.
    
    - Returns: The margins for the specified section.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForSection section: Int) -> HarmonyLayoutMargins
    
    /**
    Indicates whether or not a header is visible for the specified section.
    
    - parameter harmonyLayout: The layout for the collection view.
    - parameter section:       The section.
    
    - returns: A value that indicates whether or not a header is visible for the specified section.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, showHeaderForSection section: Int) -> Bool
    
    /**
    Asks the delegate for the margins for the specified section header. If this function isn't
    specified, then the layout's defaultHeaderMargins are used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter section:       The section for the header.
    
    - Returns: The margins for the specified section header.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForHeaderInSection section: Int) -> HarmonyLayoutMargins
    
    /**
    Asks the delegate for the margins for the specified item. If this function isn't specified,
    then the layout's defaultItemMargins are used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The margins for the specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, marginsForItemAtIndexPath indexPath: IndexPath) -> HarmonyLayoutMargins
    
    /**
    Asks the delegate for the separator inset of the item at the specified index path. If this function isn't
    specified, then `UIEdgeInsetsZero` is used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The separator insets for specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, separatorInsetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets
    
    /**
    Asks the delegate whether to hide the separator of the item at the specified index path. If this function isn't
    specified, then `false` is used instead, indicating that separator visibility should not be supressed.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: Whether the separator should be hidden.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, separatorHiddenForItemAtIndexPath indexPath: IndexPath) -> Bool
    
    /**
    Asks the delegate for the HarmoneyHighlightStyle of the item at the specified index path. If this function isn't
    specified, then `HarmoneyHighlightStyle.background` is used.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The HarmonyHighlightStyle.
    */
    
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, highlightStyleForItemAtIndexPath indexPath: IndexPath) -> HarmonyHighlightStyle
    
    /**
    Asks the delegate for the style of the item at the specified index path. If this function isn't
    specified, then the .Grouped style is used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The style for specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, styleForItemAtIndexPath indexPath: IndexPath) -> HarmonyCellStyle
    
    /**
    Asks the delegate if there should be a line break after the provided index path in a grouped
    cell style. If this function isn't specified, then it will assume `false`.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: A boolean indicating if there should be a break after the provided index path.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, breakAtIndexPath indexPath: IndexPath) -> Bool
    
    /**
    Asks the delegate for the style of the specified section. If this function isn't specified then
    the layout's `defaultSectionStyle` is used instead
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter section:       The section.
    
    - Returns: The style for the specified section. See `HarmonySectionStyle` for possible values.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, styleForSection section: Int) -> HarmonySectionStyle
    
    /**
    Asks the delegate for the tile size of the specified item. If this function isn't specified, then
    the layout's `defaultTileSize` property is used instead.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path of the item.
    
    - Returns: The tile size of the specified item. See `HarmonyTileSize` for possible values.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileSizeForItemAtIndexPath indexPath: IndexPath) -> HarmonyTileSize
    
    /**
    Asks the delegate for the tile insets of the item at the specified index path. If this function isn't
    specified, then `defaultTileInsets` is used instead.
    
    Tile insets is the space between the first or last tile and the section margins.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The tile insets for the specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileInsetsForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets
    
    /**
    Asks the delegate for the spacing between items at the specified index path. If this function isn't
    specified, then `defaultTileSpacing` is used instead.
    
    Tile spacing is the space between a tile and it's neighboring tiles.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The tile spacing for the specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, tileSpacingForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    
    /**
    Asks the delegate for the padding of the item at the specified index path. If this function isn't
    specified, then `defaultPadding` is used instead.
    
    Tile margins is the space between the tile and it's content view.
    
    - Parameter harmonyLayout: The layout for the collection view.
    - Parameter indexPath:     The index path for the item.
    
    - Returns: The tile margins for the specified item.
    */
    @objc optional func harmonyLayout(_ harmonyLayout: HarmonyLayout, paddingForItemAtIndexPath indexPath: IndexPath) -> UIEdgeInsets
}
