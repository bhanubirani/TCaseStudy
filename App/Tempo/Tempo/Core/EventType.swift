//
//  Copyright © 2016 Target. All rights reserved.
//

public protocol EventType {
    static var key: String { get }
}

public extension EventType {
    static var key: String {
        String(describing: type(of: self))
    }
}
