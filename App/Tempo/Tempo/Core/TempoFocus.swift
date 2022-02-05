//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

/**
 *  Indicates how focus should be applied to a Tempo view state.
 */
public struct TempoFocus: Equatable {
    public enum Position {
        case centeredHorizontally
        case centeredVertically
    }
    
    public enum FocusBehavior {
        case inUpdate
        case postUpdate
    }

    public let indexPath: IndexPath
    public let position: Position
    public let animated: Bool
    public let focusBehavior: FocusBehavior

    public init(indexPath: IndexPath, position: Position, animated: Bool, focusBehavior: FocusBehavior = .inUpdate) {
        self.indexPath = indexPath
        self.position = position
        self.animated = animated
        self.focusBehavior = focusBehavior
    }
}
