//
//  Dispatch.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

public func after(_ delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main, _ body: @escaping () -> Void) {
    let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    queue.asyncAfter(deadline: time, execute: body)
}
