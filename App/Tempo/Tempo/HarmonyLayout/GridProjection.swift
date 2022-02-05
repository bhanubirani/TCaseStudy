//
//  GridProjection.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

extension CGRect {
    var normalized: CGRect {
        let normalizedX = rint(minX)
        let normalizedY = rint(minY)
        let normalizedMaxX = rint(maxX)
        let normalizedMaxY = rint(maxY)

        return CGRect(x: normalizedX,
                      y: normalizedY,
                      width: normalizedMaxX - normalizedX,
                      height: normalizedMaxY - normalizedY)
    }
}

public struct GridProjection {

    // MARK: Public properties

    let width: CGFloat
    let columns: Int
    let spacing: CGFloat
    let insets: UIEdgeInsets

    // MARK: Lifecycle methodds

    public init(width: CGFloat, columns: Int = 12, spacing: CGFloat = 0.0, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.width = width
        self.columns = columns
        self.spacing = spacing
        self.insets = insets
    }

    // MARK: Public methods

    public func width(forColumns columns: Int) -> CGFloat {
        return CGFloat(columns) * columnWidth + CGFloat(columns - 1) * spacing
    }

    public func position(forColumn column: Int) -> CGFloat {
        return insets.left + CGFloat(column) * columnWidth + CGFloat(column) * spacing
    }

    public func height(forRows rows: Int) -> CGFloat {
        return CGFloat(rows) * rowHeight + CGFloat(rows - 1) * spacing
    }

    public  func position(forRow row: Int) -> CGFloat {
        return insets.top + CGFloat(row) * rowHeight + CGFloat(row) * spacing
    }

    public func project(_ rect: Grid.Rect) -> CGRect {
        return CGRect(
            x: position(forColumn: rect.x),
            y: position(forRow: rect.y),
            width: width(forColumns: rect.width),
            height: height(forRows: rect.height)
        ).normalized
    }

    // MARK: Private methods

    fileprivate var rowHeight: CGFloat {
        return (width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
    }

    fileprivate var contentWidth: CGFloat {
        return width - insets.left - insets.right
    }

    fileprivate var columnWidth: CGFloat {
        return (contentWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)
    }
}
