//
//  SinglePixelLine.swift
//  HarmonyKit
//
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

open class SinglePixelLine: UIView {
    
    open var color: UIColor = UIColor.gray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var edges: UIRectEdge = .bottom {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    open override func draw(_ rect: CGRect) {
        let lineWidth = HarmonyScreen.onePixel
        let lineInset = lineWidth / 2.0 // half the width of the line should be inside
        let insetRect = rect.inset(by: insets)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(color.cgColor)
        
        if edges.contains(.bottom)  {
            let bottomY = insetRect.maxY - lineInset
            context?.move(to: CGPoint(x: insets.left, y: bottomY))
            context?.addLine(to: CGPoint(x: insetRect.maxX, y: bottomY))
            context?.strokePath()
        }
        
        if edges.contains(.left) {
            let leftX = insets.left + lineInset
            context?.move(to: CGPoint(x: leftX, y: insets.top))
            context?.addLine(to: CGPoint(x: leftX, y: insetRect.maxY))
            context?.strokePath()
        }
        
        if edges.contains(.right) {
            let rightX = insetRect.maxX - lineInset
            context?.move(to: CGPoint(x: rightX, y: insets.top))
            context?.addLine(to: CGPoint(x: rightX, y: insetRect.maxY))
            context?.strokePath()
        }
        
        if edges.contains(.top) {
            let topY = insets.top + lineInset
            context?.move(to: CGPoint(x: insets.left, y: topY))
            context?.addLine(to: CGPoint(x: insetRect.maxX, y: topY))
            context?.strokePath()
        }
        
        context?.restoreGState()
    }
    
    // MARK: - Private Methods
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        contentMode = .redraw
    }
    
}
