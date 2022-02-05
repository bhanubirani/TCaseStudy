//
//  UIView+Autolayout.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

/// All-to-common utility for pinning a subviews edges to it's parentview edges.
extension UIView {
    public func pinSubview(_ subview: UIView) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": subview]))
    }
    
    public func addAndPinSubview(_ subview: UIView) {
        addSubview(subview)
        pinSubview(subview)
    }
    
    public func addAndCenterSubview(_ subview: UIView) {
        addSubview(subview)
        centerSubview(subview)
    }
    
    func pinSubviewToMargins(_ subview: UIView) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[subview]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[subview]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": subview]))
    }
    
    func centerSubview(_ subview: UIView) {
        addConstraints([
            NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    func addAndPinSubviewToMargins(_ subview: UIView) {
        addSubview(subview)
        pinSubviewToMargins(subview)
    }
    
}

extension UIViewController {
    public func pinRootSubview(_ subview: UIView) {
        let views: [String: AnyObject] = ["subview": subview, "topGuide": view.safeAreaLayoutGuide.topAnchor, "bottomGuide": view.safeAreaLayoutGuide.bottomAnchor]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views:views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[topGuide][subview][bottomGuide]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
    }
    
    public func addAndPinRootSubview(_ subview: UIView) {
        view.addSubview(subview)
        pinRootSubview(subview)
    }
}
