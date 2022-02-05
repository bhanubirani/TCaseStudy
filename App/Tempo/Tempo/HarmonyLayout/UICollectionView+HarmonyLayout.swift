//
//  UICollectionView+HarmonyLayout.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

/// Reference type for holding onto the views to be removed
class HarmonyLayoutHideViewHandle {
    
    fileprivate let appliedMaskViews: Set<UIView>
    
    fileprivate init(views: Set<UIView>) {
        self.appliedMaskViews = views
    }
    
    func unmask() {
        for v in appliedMaskViews {
            v.removeFromSuperview()
        }
    }
}

extension UICollectionView {
    
    /// Masks all "groups" in a section.
    func maskSection(_ section: Int) -> HarmonyLayoutHideViewHandle {
        var appliedMaskViews: Set<UIView> = []
        
        guard   let harmonyLayout = collectionViewLayout as? HarmonyLayout,
                let groupFrames = harmonyLayout.groupFramesForSection(section) else {
            assertionFailure("hide only available on collections views with HarmonyLayout")
            return HarmonyLayoutHideViewHandle(views: Set<UIView>())
        }
        
        for groupFrame in groupFrames {
            let maskView = UIView(frame: groupFrame)
            let activity = UIActivityIndicatorView(style: .medium)
            activity.center = CGPoint(x: maskView.bounds.midX, y: maskView.bounds.midY)
            activity.startAnimating()
            maskView.addSubview(activity)
            addSubview(maskView)
            maskView.layer.cornerRadius = 5
            maskView.layer.backgroundColor = UIColor.clear.cgColor
            UIView.animate(withDuration: 0.2, animations: {
                maskView.layer.backgroundColor = UIColor.targetStarkWhiteColor.withAlphaComponent(0.4).cgColor
            })
            
            // Store for later so it can be removed
            appliedMaskViews.insert(maskView)
        }
        
        return HarmonyLayoutHideViewHandle(views: appliedMaskViews)
    }
}
