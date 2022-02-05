//
//  UICollectionView+HarmonyKit.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

/// Strongly typed collection view cell dequeueing
public extension UICollectionView {
    
    /// Register a class based cell
    func registerReusable(_ cellClass: Reusable.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
    }
    
    /// Register a nib based cell
    func registerReusable(_ cellClass: ReusableNib.Type) {
        register(UINib(nibName: cellClass.nibName, bundle: Bundle(for: cellClass)), forCellWithReuseIdentifier: cellClass.reuseID)
    }
    
    // Safely dequeue a `Reusable` item
    func dequeueReusable<T: UICollectionViewCell>(_ cellType: T.Type, indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusable(cellType, reuseIdentifier: cellType.reuseID, indexPath: indexPath)
    }
    
    // Safely dequeue a `Reusable` item with a custom reuse identifier
    func dequeueReusable<T: UICollectionViewCell>(_ cellType: T.Type, reuseIdentifier: String, indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellType)!")
        }
        
        return cell
    }
}

/// Dequeuing mechanism for CollectionViewWrapperCell
public extension UICollectionView {
    
    /// Register wrapped nib based cell
    func registerWrappedReusable<T: UIView>(_ viewType: T.Type) where T: Reusable {
        registerWrappedReusable(viewType, reuseIdentifier: viewType.reuseID)
    }
    
    /// Register wrapped nib based cell with a custom reuse identifier
    func registerWrappedReusable<T: UIView>(_ viewType: T.Type, reuseIdentifier: String) where T: Reusable {
        register(CollectionViewWrapperCell<T>.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // Register wrapped nib-based supplementary view
    func registerWrappedReusable<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String) where T: Reusable {
        register(CollectionViewWrapperCell<T>.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.reuseID)
    }
    
    func dequeueWrappedReusable<T: UIView>(_ viewType: T.Type, indexPath: IndexPath) -> CollectionViewWrapperCell<T> where T: Reusable, T: Creatable {
        return dequeueWrappedReusable(viewType, reuseIdentifier: viewType.reuseID, indexPath: indexPath)
    }
    
    func dequeueWrappedReusable<T: UIView>(_ viewType: T.Type, reuseIdentifier: String, indexPath: IndexPath) -> CollectionViewWrapperCell<T> where T: Reusable, T: Creatable {
        let cell = dequeueReusable(CollectionViewWrapperCell<T>.self, reuseIdentifier: reuseIdentifier, indexPath: indexPath)
        
        if cell.reusableView == nil {
            cell.reusableView = T.create()
        }
        
        return cell
    }
    
    func dequeueWrappedReusable<T: UIView>(_ viewType: T.Type, forSupplementaryViewOfKind kind: String, indexPath: IndexPath) -> CollectionViewWrapperCell<T> where T: Reusable, T: Creatable {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewType.reuseID, for: indexPath) as Any as? CollectionViewWrapperCell<T> else {
            fatalError("Misconfigured supplementary view type, \(viewType)!")
        }
        
        if cell.reusableView == nil {
            cell.reusableView = T.create()
        }
        
        return cell
    }
}

/// UICollectionViewCell designed to wrap an arbitrary view inside of it.
public class CollectionViewWrapperCell<T: UIView>: UICollectionViewCell, Reusable where T: Reusable {
    // Static stored properties "not yet supported in Swift" 💁🏼
    public static var reuseID: String {
        return T.reuseID
    }
    
    // The private setter makes the IUO easier to swallow.
    public fileprivate(set) var reusableView: T! {
        willSet {
            reusableView?.removeFromSuperview()
        }
        didSet {
            reusableView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(reusableView)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: reusableView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: reusableView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: reusableView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: reusableView.bottomAnchor)
                ])
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        reusableView.prepareForReuse()
        setNeedsLayout()
    }
}
