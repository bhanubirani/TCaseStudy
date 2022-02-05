//
//  UIImage+HarmonyKit.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(namedFromBundle: String) {
        self.init(named: namedFromBundle, in: Bundle(for: HarmonyCellBase.self), compatibleWith: nil)
    }
    
    public convenience init?(namedFromHarmonyKitBundle: String) {
        self.init(namedFromBundle: namedFromHarmonyKitBundle)
    }
    
    @objc
    public class func imageNamedFromHarmonyKitBundle(_ named: String) -> UIImage? {
        return UIImage(namedFromHarmonyKitBundle: named)
    }
    
    public class func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    @nonobjc
    public static let clearImage = UIImage(named: "ClearPlaceholder")
}
