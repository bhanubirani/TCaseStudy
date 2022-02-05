//
//  HarmonyScreen.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public struct HarmonyScreen {
    public static let onePixel = 1 / UIScreen.main.scale
}

@objc
open class HarmonyScreenObjC: NSObject {
    public static let onePixel = 1 / UIScreen.main.scale
}
