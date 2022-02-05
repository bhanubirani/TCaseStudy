//
//  HarmonyLayoutTileGenerator.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

struct HarmonyTileGenerator: HarmonySectionGenerator {
    let layout: HarmonyLayout
    
    var grid = Grid(columns: 12)
    var indexPaths: [IndexPath]
    
    init(layout: HarmonyLayout, indexPaths: [IndexPath]) {
        self.layout = layout
        self.indexPaths = indexPaths
    }
    
    mutating func next(_ indexPath: IndexPath) -> HarmonyCellAttributes {
        let spacing = layout.tileSpacing(forIndexPath: indexPath)
        let insets = layout.tileInsets(forIndexPath: indexPath)
        let width = layout.width(forSection: indexPath.section)
        
        let projection = GridProjection(width: width, columns: grid.columns, spacing: spacing, insets: insets)
        
        let size = layout.tileSize(forIndexPath: indexPath)
        let tile = gridTile(forTileSize: size)
        let rect = grid.place(tile)
        let frame = projection.project(rect)
        
        let attributes = HarmonyCellAttributes(forCellWith: indexPath)
        
        attributes.frame = frame
        attributes.style = .none
        attributes.margins = layout.padding(forIndexPath: indexPath)
        
        return attributes
    }
    
    func gridTile(forTileSize size: HarmonyTileSize) -> Grid.Tile {
        return Grid.Tile(width: size.dimensions.columns, height: size.dimensions.rows)
    }
}
