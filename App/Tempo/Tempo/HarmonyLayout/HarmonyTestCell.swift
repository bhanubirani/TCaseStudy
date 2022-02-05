//
//  HarmonyTestCell.swift
//  HarmonyKit
//
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

open class HarmonyTestCell: HarmonyCellBase {

    // MARK: - Internal Functions

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - Private Functions

    var label: UILabel = UILabel(frame: CGRect(x: 5, y: 5, width: 200, height: 50))
    
    fileprivate func setup() {
        label.text = "Harmony"
        contentView.addSubview(label)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        label.center.y = contentView.center.y
    }
}
