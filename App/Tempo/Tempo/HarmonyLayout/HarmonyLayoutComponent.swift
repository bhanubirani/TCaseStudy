//
//  HarmonyLayoutComponent.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public protocol HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat
    func itemMarginsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyLayoutMargins
    func sectionMarginsForLayout(_ layout: HarmonyLayout) -> HarmonyLayoutMargins
    func styleForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyCellStyle
    func separatorInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
    func separatorHiddenForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> Bool
    func highlightStyleForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyHighlightStyle
    func sectionStyleForLayout(_ layout: HarmonyLayout) -> HarmonySectionStyle
    func tileSizeForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyTileSize
    func tileInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
    func tileSpacingForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> CGFloat
    func paddingForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
}

public extension HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return layout.defaultItemHeight
    }
    
    func itemMarginsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyLayoutMargins {
        return layout.defaultItemMargins
    }
    
    func sectionMarginsForLayout(_ layout: HarmonyLayout) -> HarmonyLayoutMargins {
        return layout.defaultSectionMargins
    }
    
    func styleForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyCellStyle {
        return layout.defaultItemStyle
    }
    
    func separatorInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultSeparatorInsets
    }
    
    func separatorHiddenForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> Bool {
        return false
    }
    
    func highlightStyleForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyHighlightStyle {
        return layout.defaultHighlightStyle
    }
    
    func tileSizeForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyTileSize {
        return layout.defaultTileSize
    }
    
    func tileInsetsForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultTileInsets
    }
    
    func tileSpacingForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> CGFloat {
        return layout.defaultTileSpacing
    }
    
    func paddingForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultPadding
    }
    
    func sectionStyleForLayout(_ layout: HarmonyLayout) -> HarmonySectionStyle {
        return layout.defaultSectionStyle
    }
    
    func fittingHeightForView(_ componentView: UIView, width: CGFloat) -> CGFloat {
        componentView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: componentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
        componentView.addConstraint(widthConstraint)
        
        componentView.setNeedsLayout()
        componentView.layoutIfNeeded()
        
        let fittingSize = componentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        componentView.removeConstraint(widthConstraint)
        
        return fittingSize.height
    }
}
