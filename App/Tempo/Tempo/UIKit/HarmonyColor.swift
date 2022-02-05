//
//  HarmonyColor.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

// MARK: - Color Builders

private func colorWithHSB(h: CGFloat, s: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(hue: h / 360.0, saturation: s / 100.0, brightness: b / 100.0, alpha: 1.0)
}

private func colorWithRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

/// Harmony Color Theme
public struct HarmonyColor {
    // MARK: - Grays
    
    /**
     *  RGB: 38, 38, 38
     */
    public static var targetJetBlackColor = colorWithHSB(h: 0, s: 0, b: 20.0)
    
    /**
     *  RGB: 119, 119, 119
     */
    public static var targetNeutralGrayColor = colorWithHSB(h: 0, s: 0, b: 40.0)
    
    /**
     *  RGB: 214, 214, 214
     */
    public static var targetStrokeGrayColor = colorWithHSB(h: 0, s: 0, b: 84.0)
    
    /**
     *  RGB: 247, 247, 247
     */
    public static var targetFadeAwayGrayColor = colorWithHSB(h: 0, s: 0, b: 97.0)

    public static var targetMapBackgroundColor = targetFadeAwayGrayColor

    /**
     *  RGB: 255, 255, 255
     */
    public static var targetStarkWhiteColor = colorWithHSB(h: 0.0, s: 0.0, b: 100.0)
    
    // MARK: - Bright Colors

    public static var targetBullseyeRedColor = colorWithHSB(h: 0.0, s: 100.0, b: 80.0)
    
    public static var targetAttentionOrangeColor = colorWithHSB(h: 27.16, s: 100.0, b: 90.98)
    
    public static var targetCuriousYellowColor = colorWithHSB(h: 50.59, s: 100.0, b: 100.0)
    
    public static var targetChoiceGreenColor = colorWithHSB(h: 120.0, s: 100.0, b: 63.53)
    
    public static var targetActionBlueColor = colorWithHSB(h: 221.0, s: 77.0, b: 86.0)
    
    // MARK: - Diffuse Colors
    
    public static var targetRonBurgundyColor = colorWithHSB(h: 0.0, s: 100.0, b: 67.0)
    
    public static var targetTabooBrown = colorWithHSB(h: 27.07, s: 100.0, b: 72.16)
    
    public static var targetCream = colorWithHSB(h: 39.0, s: 18.0, b: 91.0)

    public static var targetEugeneGreen = colorWithHSB(h: 120.0, s: 100.0, b: 51.37)
    
    public static var targetMapOverlayColor = colorWithHSB(h: 37.0, s: 3.0, b: 98.0)
    
    // State Based Colors
    public static var targetSelectionOverlayColor = UIColor(white: 0, alpha: 0.06)
    
    // Special Event Colors
    public static var targetBlackFridayBlackColor = colorWithHSB(h: 81.0, s: 0.0, b: 1.0)
    
    public static var targetBlackFridayCharcoalColor = colorWithHSB(h: 81.0, s: 0.0, b: 9.0)
    
    public static var targetBlackFridayGreenColor = colorWithHSB(h: 81.0, s: 96.0, b: 100.0)

}

/// Legacy API proxy
extension UIColor {
    
    public class var targetJetBlackColor: UIColor {
        return HarmonyColor.targetJetBlackColor
    }
    
    public class var targetNeutralGrayColor: UIColor {
        return HarmonyColor.targetNeutralGrayColor
    }
    
    public class var targetStrokeGrayColor: UIColor {
        return HarmonyColor.targetStrokeGrayColor
    }
    
    public class var targetFadeAwayGrayColor: UIColor {
        return HarmonyColor.targetFadeAwayGrayColor
    }
    
    
    public class var targetMapBackgroundColor: UIColor {
        return HarmonyColor.targetMapBackgroundColor
    }
    
    public class var targetStarkWhiteColor: UIColor {
        return HarmonyColor.targetStarkWhiteColor
    }
    
    public class var targetBullseyeRedColor: UIColor {
        return HarmonyColor.targetBullseyeRedColor
    }
    
    public class var targetAttentionOrangeColor: UIColor {
        return HarmonyColor.targetAttentionOrangeColor
    }
    
    public class var targetCuriousYellowColor: UIColor {
        return HarmonyColor.targetCuriousYellowColor
    }
    
    public class var targetChoiceGreenColor: UIColor {
        return HarmonyColor.targetChoiceGreenColor
    }
    
    public class var targetActionBlueColor: UIColor {
        return HarmonyColor.targetActionBlueColor
    }
    
    public class var targetRonBurgundyColor: UIColor {
        return HarmonyColor.targetRonBurgundyColor
    }
    
    public class var targetCream: UIColor {
        return HarmonyColor.targetCream
    }
    
    public class var targetTabooBrown: UIColor {
        return HarmonyColor.targetTabooBrown
    }
    
    public class var targetEugeneGreen: UIColor {
        return HarmonyColor.targetEugeneGreen
    }
    
    public class var targetMapOverlayColor: UIColor {
        return HarmonyColor.targetMapBackgroundColor
    }
    
    public class var targetSelectionOverlayColor: UIColor {
        return HarmonyColor.targetSelectionOverlayColor
    }
    
    public class var targetBlackFridayBlackColor: UIColor {
        return HarmonyColor.targetBlackFridayBlackColor
    }
    
    public class var targetBlackFridayGreenColor: UIColor {
        return HarmonyColor.targetBlackFridayGreenColor
    }
    
    public class var targetBlackFridayCharcoalColor: UIColor {
        return HarmonyColor.targetBlackFridayCharcoalColor
    }
    
}
