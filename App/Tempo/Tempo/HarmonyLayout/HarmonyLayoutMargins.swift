//
//  HarmonyLayout.swift
//  Harmony
//
//  Copyright (c) 2015 Target. All rights reserved.
//

public enum HarmonyLayoutMarginStyle {
    // Legacy margins
    case none
    case narrow
    case wide

    // New margins
    case quarter
    case half
    case full

    public var points: CGFloat {
        switch self {
        case .none:
            return 0.0

        case .quarter, .narrow:
            return 4.0

        case .half:
            return 8.0

        case .full, .wide:
            return 16.0
        }
    }
}

@objc
open class HarmonyLayoutMargins: NSObject {
    open var top: HarmonyLayoutMarginStyle
    open var right: HarmonyLayoutMarginStyle
    open var bottom: HarmonyLayoutMarginStyle
    open var left: HarmonyLayoutMarginStyle
    
    public init(top: HarmonyLayoutMarginStyle,
                right: HarmonyLayoutMarginStyle,
                bottom: HarmonyLayoutMarginStyle,
                left: HarmonyLayoutMarginStyle) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
    
    public static let HarmonyLayoutMarginsZero = HarmonyLayoutMargins(top: .none, right: .none, bottom: .none, left: .none)
}
