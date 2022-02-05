//
//  Reusable.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

/// Shared protocol to represent reusable items, e.g. table or collection view cells
public protocol Reusable: AnyObject {
    static var reuseID: String { get }
    func prepareForReuse()
}

public extension Reusable {
    // Optional prepareForReuse
    func prepareForReuse() { }
}

/*
Used to provide an public-ended way to make a parameterless factory for any object.

Examples: init() or loaded from a xib.
*/
public protocol Creatable {
    static func create() -> Self
}

/// Derivative of `Reusable` that supports registering via nib
public protocol ReusableNib: Reusable, Creatable, NibLoadedType {
    static var nibName: String { get }
}

/// Reusable nibs are created using their `NibLoadedType` abilities.
extension Reusable where Self: ReusableNib {
    public static func create() -> Self {
        return loadFromNib()
    }
}

/*
Reusable views (views that are created using code alone) need to declare
a public initializer.
*/
public protocol ReusableView: Reusable, Creatable {
    init()
}

/// Reusable views then simply implement `create()` with the default initializer.
extension Reusable where Self: ReusableView {
    public static func create() -> Self {
        return Self.init()
    }
}
