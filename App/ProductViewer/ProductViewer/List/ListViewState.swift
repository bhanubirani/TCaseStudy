//
//  ListViewState.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

/// List view state
struct ListViewState: TempoViewState, TempoSectionedViewState {
    var listItems: [ListItem]
    
    var sections: [TempoViewStateSection] {
        return [ListSection(listItems: listItems)]
    }
}

struct ListSection: TempoViewStateSection, Equatable {
    let listItems: [ListItem]
    
    var items: [TempoViewStateItem] {
        return listItems
    }
}

/// View state for each list item.
struct ListItem: TempoViewStateItem, Equatable {
    let title: String
    let price: String
    let image: UIImage?
}
