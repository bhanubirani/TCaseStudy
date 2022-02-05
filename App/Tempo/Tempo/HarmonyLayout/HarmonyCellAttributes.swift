//
//  HarmonyCellAttributes.swift
//  Harmony
//
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Custom attributes for Harmony-styled collection view items.
 */
final class HarmonyCellAttributes: UICollectionViewLayoutAttributes {
    // MARK: - Internal Properties
    
    /// Indicates how the cell at this index path should be displayed.
    var style = HarmonyCellStyle.grouped

    /// Indicates how the call will show a highlighted state.
    var highlightStyle = HarmonyHighlightStyle.background
    
    /// Indicates where this cell appears in a group of cells.
    var position = HarmonyCellPosition.solo
    
    /// Indicates the edge insets of the cell separator.
    var separatorInsets = UIEdgeInsets.zero

    /// Indicates the space between the cell and its content.
    var margins = UIEdgeInsets.zero
}

// MARK: - UICollectionViewLayoutAttributes

extension HarmonyCellAttributes {
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? HarmonyCellAttributes {
            return self.style == object.style &&
                self.highlightStyle == object.highlightStyle &&
                self.position == object.position &&
                self.separatorInsets == object.separatorInsets &&
                self.margins == object.margins &&
                super.isEqual(object)
        } else {
            return false
        }
    }
}

// MARK: - NSCopying

extension HarmonyCellAttributes {
    override func copy(with zone: NSZone?) -> Any {
        let cell = super.copy(with: zone) as! HarmonyCellAttributes
        cell.style = self.style
        cell.highlightStyle = self.highlightStyle
        cell.position = self.position
        cell.separatorInsets = self.separatorInsets
        cell.margins = self.margins
        
        return cell
    }
}
