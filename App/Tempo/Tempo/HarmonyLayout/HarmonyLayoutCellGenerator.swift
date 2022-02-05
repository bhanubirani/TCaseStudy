//
//  HarmonyLayoutCellGenerator.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

struct HarmonyCellGenerator: HarmonySectionGenerator {
    let layout: HarmonyLayout
    let itemCount: Int

    var indexPaths: [IndexPath]
    var y: CGFloat = 0

    init(layout: HarmonyLayout, indexPaths: [IndexPath]) {
        self.layout = layout
        self.indexPaths = indexPaths
        self.itemCount = indexPaths.count
    }

    func predecessor(_ indexPath: IndexPath) -> IndexPath? {
        let isFirstItem = indexPath.item == 0
        return isFirstItem ? nil : IndexPath(item: indexPath.item - 1, section: indexPath.section)
    }

    func successor(_ indexPath: IndexPath) -> IndexPath? {
        let isLastItem = indexPath.item == itemCount - 1
        return isLastItem ? nil : IndexPath(item: indexPath.item + 1, section: indexPath.section)
    }

    mutating func next(_ indexPath: IndexPath) -> HarmonyCellAttributes {
        let style = layout.style(forItemAtIndexPath: indexPath)

        let previousIndexPath = predecessor(indexPath)
        let nextIndexPath = successor(indexPath)

        let previousItemStyle = previousIndexPath.flatMap(layout.style)
        let nextItemStyle = nextIndexPath.flatMap(layout.style)

        let isFirstItem = indexPath.item == 0
        let isLastItem = indexPath.item == itemCount - 1
        let isMiddleItem = !isFirstItem && !isLastItem

        let isDetached = determineIfDetached(style, indexPath: indexPath)
        let previousItemIsDetached = determineIfDetached(previousItemStyle, indexPath: previousIndexPath)
        let nextItemIsDetached = determineIfDetached(nextItemStyle, indexPath: nextIndexPath)

        let isSoloItem = itemCount == 1 || isDetached ||
            (isFirstItem && nextItemIsDetached) ||
            (isLastItem && previousItemIsDetached) ||
            (isMiddleItem && previousItemIsDetached && nextItemIsDetached)

        let position: HarmonyCellPosition

        if isSoloItem {
            position = .solo
        } else if isFirstItem || (isMiddleItem && previousItemIsDetached) {
            position = .top
        } else if isLastItem || (isMiddleItem && nextItemIsDetached) {
            position = .bottom
        } else {
            position = .middle
        }

        let separatorInsets = layout.separatorInsets(forItemAtIndexPath: indexPath)

        let topMargin: CGFloat
        if (!isFirstItem && isDetached) || (!isDetached && previousItemIsDetached) {
            // Add top margin for detached items.
            topMargin = HarmonyLayoutMarginStyle.narrow.points
        } else {
            topMargin = 0
        }

        let leftMargin = layout.margins(forSection: indexPath.section).left.points + layout.margins(forItemAtIndexPath: indexPath).left.points

        let width = layout.width(forItemAtIndexPath: indexPath)
        let height = layout.height(forItemAtIndexPath: indexPath, width: width) + (style == .horizontalRule ? 1 : 0)

        let attributes = HarmonyCellAttributes(forCellWith: indexPath)

        attributes.frame = CGRect(x: leftMargin, y: y + topMargin, width: width, height: height)
        attributes.position = position
        attributes.style = style
        attributes.separatorInsets = separatorInsets

        y += height + topMargin

        return attributes
    }

    // Detached if the style is detached, or delegate indicates that there is a break.
    func determineIfDetached(_ style: HarmonyCellStyle?, indexPath: IndexPath?) -> Bool {
        if style == .detached {
            return true
        } else if let indexPath = indexPath {
            return layout.hasBreak(atIndexPath: indexPath)
        } else {
            return false
        }
    }
}
