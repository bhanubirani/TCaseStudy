//
//  Copyright © 2020 Target. All rights reserved.
//

/// Elements that have a stable identity across different instances.
public protocol TempoIdentifiable {
    /// The stable identifier.
    var identifier: String { get }
}

public extension TempoIdentifiable {
    var identifier: String { String(describing: type(of: self)) }
}

/// Elements that can have visual focus in Tempo.
public protocol TempoFocusable {
    /// If the element has visual focus.
    var focused: Bool { get }
}

public extension TempoFocusable {
    var focused: Bool { false }
}
