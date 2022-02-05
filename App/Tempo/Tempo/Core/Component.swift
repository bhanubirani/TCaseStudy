//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public protocol ComponentType {
    var dispatcher: Dispatcher? { get set }
    
    func canDisplayItem(_ item: TempoViewStateItem) -> Bool
    
    func prepareView(_ view: UIView, viewState: TempoViewStateItem)
    func configureView(_ view: UIView, viewState: TempoViewStateItem)
    func selectView(_ view: UIView, viewState: TempoViewStateItem)
    func shouldSelectView(_ view: UIView, viewState: TempoViewStateItem) -> Bool
    func shouldHighlightView(_ view: UIView, viewState: TempoViewStateItem) -> Bool
    func didFocus(_ frame: CGRect?, coordinateSpace: UICoordinateSpace?, viewState: TempoViewStateItem)
    func focusAccessibility(_ view: UIView, viewState: TempoViewStateItem)
    
    func registerWrapper(_ container: ReusableViewContainer)
    func registerWrapper(_ container: ReusableViewContainer, forSupplementaryViewOfKind kind: String)
    
    func dequeueWrapper(_ container: ReusableViewItemContainer) -> ComponentWrapper
    func dequeueWrapper(_ container: ReusableViewItemContainer, forSupplementaryViewOfKind kind: String) -> ComponentWrapper
    
    func visibleWrapper(_ container: ReusableViewItemContainer) -> ComponentWrapper?
    func visibleWrapper(_ container: ReusableViewItemContainer, forSupplementaryViewOfKind kind: String) -> ComponentWrapper?
}

public extension ComponentType {
    func prepareView(_ view: UIView, viewState: TempoViewStateItem) {}
    func selectView(_ view: UIView, viewState: TempoViewStateItem) {}
    func shouldSelectView(_ view: UIView, viewState: TempoViewStateItem) -> Bool { true }
    func shouldHighlightView(_ view: UIView, viewState: TempoViewStateItem) -> Bool { shouldSelectView(view, viewState: viewState) }
    func didFocus(_ frame: CGRect?, coordinateSpace: UICoordinateSpace?, viewState: TempoViewStateItem) {}
    func focusAccessibility(_ view: UIView, viewState: TempoViewStateItem) {}
}

public protocol Component: ComponentType {
    associatedtype Item: TempoViewStateItem
    associatedtype View: UIView

    /// Prepare the provided view for (re)use.
    /// - Parameter view: The view to prepare for (re)use
    /// - Parameter item: The item about to be displayed in the view. This is provided for legacy
    ///      compatibility. It should not be used in `prepareView` implementations. Updates that
    ///      depend on `item` should be performed in `configureView` instead.
    func prepareView(_ view: View, item: Item)

    /// Configure the provided view to display the item.
    /// - Parameter view: The view to configure
    /// - Parameter item: The item to configure the view with.
    func configureView(_ view: View, item: Item)

    /// Inform the `Component` that the user selected the view.
    /// - Parameter view: The view that was selected
    /// - Parameter item: The item the view is currently displaying.
    func selectView(_ view: View, item: Item)

    /// Ask the component if the view should be selectable. Defaults to `true`.
    /// - Parameter view: The view that could be selected.
    /// - Parameter item: The item the view is currently displaying.
    /// - Returns: Whether or not the view should be selectable.
    func shouldSelectView(_ view: View, item: Item) -> Bool

    /// Ask the component if the view should highlight when the user taps on it. Defaults to value
    /// returned from `shouldSelectView`.
    /// - Parameter view: The view that could be highlighted.
    /// - Parameter item: The item the view is currently displaying.
    /// - Returns: Whether or not the view should highlight when tapped.
    func shouldHighlightView(_ view: View, item: Item) -> Bool

    func didFocus(_ frame: CGRect?, coordinateSpace: UICoordinateSpace?, item: Item)
    func focusAccessibility(_ view: View, item: Item)
    
    func dequeueWrapper(_ container: ReusableViewItemContainer) -> ComponentWrapper
    func dequeueWrapper(_ container: ReusableViewItemContainer, forSupplementaryViewOfKind kind: String) -> ComponentWrapper
    
    func visibleWrapper(_ container: ReusableViewItemContainer) -> ComponentWrapper?
    func visibleWrapper(_ container: ReusableViewItemContainer, forSupplementaryViewOfKind kind: String) -> ComponentWrapper?
}

public extension Component {
    func prepareView(_ view: View, item: Item) {}
    func selectView(_ view: View, item: Item) {}
    func shouldSelectView(_ view: View, item: Item) -> Bool { true }
    func shouldHighlightView(_ view: View, item: Item) -> Bool { shouldSelectView(view, item: item) }
    func didFocus(_ frame: CGRect?, coordinateSpace: UICoordinateSpace?, item: Item) {}
    func focusAccessibility(_ view: View, item: Item) {}
}

public extension ComponentType where Self: Component {
    func withSpecificView<T>(_ view: UIView, viewState: TempoViewStateItem, perform: (View, Item) -> T) -> T {
        perform(view as! Self.View, viewState as! Self.Item)
    }
    
    func canDisplayItem(_ item: TempoViewStateItem) -> Bool {
        item is Item
    }
    
    func prepareView(_ view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            prepareView(view, item: item)
        }
    }
    
    func configureView(_ view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            configureView(view, item: item)
        }
    }
    
    func selectView(_ view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            selectView(view, item: item)
        }
    }
    
    func shouldSelectView(_ view: UIView, viewState: TempoViewStateItem) -> Bool {
        withSpecificView(view, viewState: viewState) { view, item in
            shouldSelectView(view, item: item)
        }
    }
    
    func shouldHighlightView(_ view: UIView, viewState: TempoViewStateItem) -> Bool {
        withSpecificView(view, viewState: viewState) { view, item in
            shouldHighlightView(view, item: item)
        }
    }
    
    func didFocus(_ frame: CGRect?, coordinateSpace: UICoordinateSpace?, viewState: TempoViewStateItem) {
        didFocus(frame, coordinateSpace: coordinateSpace, item: viewState as! Self.Item)
    }
    
    func focusAccessibility(_ view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            focusAccessibility(view, item: item)
        }
    }
}

public extension Component where View: Reusable, View: Creatable {
    func registerWrapper(_ container: ReusableViewContainer) {
        container.registerReusableView(View.self)
    }
    
    func registerWrapper(_ container: ReusableViewContainer, forSupplementaryViewOfKind kind: String) {
        container.registerReusableView(View.self, forSupplementaryViewOfKind: kind)
    }
    
    func dequeueWrapper(_ container: ReusableViewItemContainer) -> ComponentWrapper {
        container.dequeueReusableWrapper(View.self)
    }
    
    func dequeueWrapper(_ container: ReusableViewItemContainer, forSupplementaryViewOfKind kind: String) -> ComponentWrapper {
        container.dequeueReusableWrapper(View.self, forSupplementaryViewOfKind: kind)
    }
    
    func visibleWrapper(_ container: ReusableViewItemContainer) -> ComponentWrapper? {
        container.visibleWrapper(View.self)
    }
    
    func visibleWrapper(_ container: ReusableViewItemContainer, forSupplementaryViewOfKind kind: String) -> ComponentWrapper? {
        container.visibleWrapper(View.self, forSupplementaryViewOfKind: kind)
    }
}
