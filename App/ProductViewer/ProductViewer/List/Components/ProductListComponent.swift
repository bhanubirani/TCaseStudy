//
//  ProductListComponent.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ProductListComponent: Component {
    var dispatcher: Dispatcher?

    func prepareView(_ view: ProductListView, item: ListItem) {
        // Called on first view or ProductListView
    }
    
    func configureView(_ view: ProductListView, item: ListItem) {
        view.titleLabel.text = item.title
        view.priceLabel.text = item.price
        view.productImage.image = item.image
    }
    
    func selectView(_ view: ProductListView, item: ListItem) {
        dispatcher?.triggerEvent(ListItemPressed())
    }
}

extension ProductListComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 100.0
    }
}
