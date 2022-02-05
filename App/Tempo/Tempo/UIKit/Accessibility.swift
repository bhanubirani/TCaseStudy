//
//  Accessibility.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

@objc open class Accessibility : NSObject {
    public static func announce(_ announcement: String) {
        UIAccessibility.post(notification: .announcement, argument: announcement)
    }

    public static func announce(_ announcement: String, afterDelay delay: TimeInterval) {
        after(delay) {
            announce(announcement)
        }
    }
    
    /**
     *  If you add/remove elements from the screen and don't want to give them focus, posting a layout changed notification will make them discoverable/undiscoverable for accessibility.
     *
     *  - Parameter announcement: An optional announcement to coincide with the layout change.
     */
    public static func postLayoutChanged(_ announcement: String? = nil) {
        UIAccessibility.post(notification: .layoutChanged, argument: announcement);
    }

    public static func announceScreenChanged(andFocusView view: UIView) {
        UIAccessibility.post(notification: .screenChanged, argument: view)
    }

    public static func announceScreenChanged(andSpeakAnnouncement announcement: String) {
        UIAccessibility.post(notification: .screenChanged, argument: announcement)
    }
    
    public static func announceScreenChanged(andSpeakAnnouncement announcement: String, afterDelay delay: TimeInterval) {
        after(delay) {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: announcement)
        }
    }
}

public extension UIView {
    func focusAccessibility() {
        UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: self);
    }

    func focusAccessibility(afterDelay delay: TimeInterval) {
        after(delay) {
            self.focusAccessibility()
        }
    }
}
