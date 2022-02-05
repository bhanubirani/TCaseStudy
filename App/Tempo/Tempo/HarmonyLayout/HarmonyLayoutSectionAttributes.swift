//
//  HarmonyLayoutSectionAttributes.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

/**
 A type that represents a section of items in `HarmonyLayout`.

 As a sequence, a section allows the use of `for` to iterate over the layout attributes:

     for attributes in section {
         // 💁 attributes are UICollectionViewAttributes
     }

 Per `SequenceType`, sections are destructively "consumed" by iteration, since the calculation
 of a given layout attributes can be dependent on previous iterations.
 */
struct HarmonyLayoutSectionAttributes: Sequence {
    let style: HarmonySectionStyle
    let indexPaths: [IndexPath]
    let layout: HarmonyLayout

    init(indexPaths: [IndexPath], layout: HarmonyLayout, style: HarmonySectionStyle) {
        self.indexPaths = indexPaths
        self.layout = layout
        self.style = style
    }

    func makeIterator() -> AnyIterator<HarmonyCellAttributes> {
        switch style {
        case .grid:
            return AnyIterator(HarmonyTileGenerator(layout: layout, indexPaths: indexPaths))
        case .list:
            return AnyIterator(HarmonyCellGenerator(layout: layout, indexPaths: indexPaths))
        }
    }
}

extension HarmonyLayoutSectionAttributes {
    /**
     Returns a new section that offsets the frame of the section's attributes vertically by the
     given amount.

     - Parameter dx: The amount to offset horizontally in points.
     - Parameter dy: The amount to offset vertically in points.
     */
    func offsetBy(dx: CGFloat, dy: CGFloat) -> AnySequence<HarmonyCellAttributes> {
        return AnySequence(
            map { attributes in
                let attrs = attributes.copy() as! HarmonyCellAttributes
                attrs.frame = attributes.frame.offsetBy(dx: dx, dy: dy)
                return attrs
            }
        )
    }
}

protocol HarmonySectionGenerator: IteratorProtocol {
    var indexPaths: [IndexPath] { get set }

    mutating func next(_ indexPath: IndexPath) -> HarmonyCellAttributes
}

extension HarmonySectionGenerator {
    mutating func next() -> HarmonyCellAttributes? {
        guard let indexPath = indexPaths[indexPaths.indices].popFirst() else {
            return nil
        }

        return next(indexPath)
    }
}
