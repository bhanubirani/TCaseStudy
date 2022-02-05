//
//  Copyright © 2017 Target. All rights reserved.
//

import Foundation
import UIKit

public struct ReusableCollectionViewContainer: ReusableViewContainer {
    let collectionView: UICollectionView
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func registerReusableView<T: UIView>(_ viewType: T.Type) where T: Reusable, T: Creatable {
        collectionView.registerWrappedReusable(viewType)
    }
    
    public func registerReusableView<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) where T: Reusable, T: Creatable {
        collectionView.registerWrappedReusable(viewType, forSupplementaryViewOfKind: kind)
    }
    
    public func reusableViewItemContainer(fromIndexPath: IndexPath, toIndexPath: IndexPath) -> ReusableViewItemContainer {
        ReusableCollectionViewItemContainer(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath, collectionView: collectionView)
    }
}

// MARK: - ReusableCollectionViewItemContainer

private struct ReusableCollectionViewItemContainer: ReusableViewItemContainer {
    var fromIndexPath: IndexPath
    var toIndexPath: IndexPath
    var collectionView: UICollectionView
    
    init(fromIndexPath: IndexPath, toIndexPath: IndexPath, collectionView: UICollectionView) {
        self.fromIndexPath = fromIndexPath
        self.toIndexPath = toIndexPath
        self.collectionView = collectionView
    }
        
    func dequeueReusableWrapper<T: UIView>(_ viewType: T.Type, reuseIdentifier: String) -> ComponentWrapper where T: Reusable, T: Creatable {
        let cell = collectionView.dequeueWrappedReusable(viewType, reuseIdentifier: reuseIdentifier, indexPath: toIndexPath)
        return ComponentWrapper(cell: cell, view: cell.reusableView)
    }
    
    func dequeueReusableWrapper<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) -> ComponentWrapper where T: Reusable, T: Creatable {
        let cell = collectionView.dequeueWrappedReusable(viewType, forSupplementaryViewOfKind: kind, indexPath: toIndexPath)
        return ComponentWrapper(cell: cell, view: cell.reusableView)
    }
    
    func visibleWrapper<T: UIView>(_ viewType: T.Type) -> ComponentWrapper? where T: Reusable, T: Creatable {
        guard let cell = collectionView.cellForItem(at: fromIndexPath) as Any as? CollectionViewWrapperCell<T> else {
            return nil
        }
        
        return ComponentWrapper(cell: cell, view: cell.reusableView)
    }
    
    func visibleWrapper<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) -> ComponentWrapper? where T: Reusable, T: Creatable {
        guard let cell = collectionView.supplementaryView(forElementKind: kind, at: fromIndexPath) as Any as? CollectionViewWrapperCell<T> else {
            return nil
        }
        
        return ComponentWrapper(cell: cell, view: cell.reusableView)
    }
}

// MARK: - ReusableViewContainer

public protocol ReusableViewContainer {
    init(collectionView: UICollectionView)
    
    func registerReusableView<T: UIView>(_ viewType: T.Type) where T: Reusable, T: Creatable
    func registerReusableView<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) where T: Reusable, T: Creatable
    func reusableViewItemContainer(fromIndexPath: IndexPath, toIndexPath: IndexPath) -> ReusableViewItemContainer
}

// MARK: - ReusableViewItemContainer

public protocol ReusableViewItemContainer {
    func dequeueReusableWrapper<T: UIView>(_ viewType: T.Type) -> ComponentWrapper where T: Reusable, T: Creatable
    func dequeueReusableWrapper<T: UIView>(_ viewType: T.Type, reuseIdentifier: String) -> ComponentWrapper where T: Reusable, T: Creatable
    func dequeueReusableWrapper<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) -> ComponentWrapper where T: Reusable, T: Creatable
    func visibleWrapper<T: UIView>(_ viewType: T.Type) -> ComponentWrapper? where T: Reusable, T: Creatable
    func visibleWrapper<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) -> ComponentWrapper? where T: Reusable, T: Creatable
}

public extension ReusableViewItemContainer {
    func dequeueReusableWrapper<T: UIView>(_ viewType: T.Type) -> ComponentWrapper where T: Reusable, T: Creatable {
        return dequeueReusableWrapper(viewType, reuseIdentifier: viewType.reuseID)
    }
}
