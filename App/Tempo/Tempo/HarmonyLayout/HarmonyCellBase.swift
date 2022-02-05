//
//  HarmonyCellBase.swift
//  Harmony
//
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Harmony styled cell for use in HarmonyLayout collection views. The cell supports multiple styles
 *  as defined in the designs.
 */
open class HarmonyCellBase: UICollectionViewCell {
    // MARK: - Private Class Properties
    
    
    fileprivate static var backgroundImageSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundSolo")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var backgroundImageTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundTop")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 1.0, right: 5.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var backgroundImageMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundMiddle")
        let capInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right: 1.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var backgroundImageBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundBottom")
        let capInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var backgroundImageHorizontalRule: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundHorizontalRule")
        let capInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var backgroundImagePlainTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainTop")
        let capInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 0.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var backgroundImagePlainMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainMiddle")
        let capInsets = UIEdgeInsets(top: 2.0, left: 1.0, bottom: 0.0, right: 1.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var backgroundImagePlainBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainBottom")
        let capInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 2.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var backgroundImagePlainSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainSolo")
        let capInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 1.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var highlightedBackgroundImageSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundSolo")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var highlightedBackgroundImageTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundTop")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 1.0, right: 5.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var highlightedBackgroundImageMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundMiddle")
        let capInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right: 1.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var highlightedBackgroundImageBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundBottom")
        let capInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()
    
    fileprivate static var highlightedBackgroundImageHorizontalRule: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundHorizontalRule")
        let capInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var highlightedBackgroundImagePlainTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainTop")
        let capInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 0.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var highlightedBackgroundImagePlainMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainMiddle")
        let capInsets = UIEdgeInsets(top: 3.0, left: 1.0, bottom: 0.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var highlightedBackgroundImagePlainBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainBottom")
        let capInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 2.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    fileprivate static var highlightedBackgroundImagePlainSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainSolo")
        let capInsets = UIEdgeInsets(top: 2.0, left: 1.0, bottom: 1.0, right: 0.0)
        return image?.resizableImage(withCapInsets: capInsets)
    }()

    // MARK: - Private Properties
    
    fileprivate var backgroundImageView: UIImageView?
    fileprivate var highlightedBackgroundImageView: UIImageView?
    fileprivate var singlePixelLine: SinglePixelLine?
    fileprivate let highlightedForegroundImageView: UIImageView = UIImageView()
    fileprivate var highlightStyle: HarmonyHighlightStyle = .background
    
    // MARK: - Internal Functions
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(frame: frame)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }
    
    // MARK: - Private Functions
    
    fileprivate func setup(frame: CGRect) {
        contentView.layoutMargins = UIEdgeInsets.zero

        backgroundView = UIView(frame: frame)
        backgroundView?.backgroundColor = .clear

        backgroundImageView = UIImageView(image: HarmonyCellBase.backgroundImageSolo)
        backgroundImageView?.backgroundColor = .clear
        backgroundView?.addSubview(backgroundImageView!)
        
        highlightedBackgroundImageView = UIImageView(image: HarmonyCellBase.highlightedBackgroundImageSolo)
        highlightedBackgroundImageView?.backgroundColor = .clear
        highlightedBackgroundImageView?.isHidden = true
        backgroundView?.addSubview(highlightedBackgroundImageView!)

        singlePixelLine = SinglePixelLine(frame: frame)
        singlePixelLine?.edges = UIRectEdge()
        backgroundView?.addSubview(singlePixelLine!)

        highlightedForegroundImageView.backgroundColor = UIColor.targetJetBlackColor.withAlphaComponent(0.03)
        highlightedForegroundImageView.isHidden = true
        contentView.addSubview(highlightedForegroundImageView)
    }
}

// MARK: - UICollectionViewCell

extension HarmonyCellBase {
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // This override prevents self-sizing operations from taking place, which slow down complex layouts.
        return layoutAttributes
    }

    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attributes = layoutAttributes as? HarmonyCellAttributes {
            contentView.layoutMargins = attributes.margins
            highlightStyle = attributes.highlightStyle

            switch attributes.style {
            case .none:
                backgroundColor = .clear
                backgroundImageView?.isHidden = true
                highlightedBackgroundImageView?.image = nil
                singlePixelLine?.edges = UIRectEdge()
            case .grouped:
                backgroundColor = .clear
                backgroundImageView?.isHidden = false
                
                switch attributes.position {
                case .solo:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageSolo
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageSolo

                    singlePixelLine?.edges = UIRectEdge()
                case .top:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageTop
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageTop
                    
                    singlePixelLine?.edges = .bottom
                    singlePixelLine?.insets = attributes.separatorInsets
                    
                case .middle:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageMiddle
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageMiddle
                    
                    singlePixelLine?.edges = .bottom
                    singlePixelLine?.insets = attributes.separatorInsets
                    
                case .bottom:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageBottom
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageBottom

                    singlePixelLine?.edges = UIRectEdge()
                }
                
            case .detached:
                backgroundColor = .clear
                backgroundImageView?.isHidden = false
                backgroundImageView?.image = HarmonyCellBase.backgroundImageSolo
                highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageSolo
                singlePixelLine?.edges = UIRectEdge()
            case .horizontalRule:
                backgroundColor = .clear
                backgroundImageView?.isHidden = false
                backgroundImageView?.image = HarmonyCellBase.backgroundImageHorizontalRule
                highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageHorizontalRule
                singlePixelLine?.edges = UIRectEdge()
            case .plain:
                backgroundColor = .white
                backgroundImageView?.isHidden = false
                singlePixelLine?.insets = attributes.separatorInsets

                switch attributes.position {
                case .solo:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainSolo
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainSolo
                    singlePixelLine?.edges = UIRectEdge()
                case .top:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainTop
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainTop
                    singlePixelLine?.edges = .bottom
                case .middle:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainMiddle
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainMiddle
                    singlePixelLine?.edges = .bottom
                case .bottom:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainBottom
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainBottom
                    singlePixelLine?.edges = UIRectEdge()
                }

            }
        } else {
            layoutMargins = UIEdgeInsets.zero
            backgroundColor = .clear
            backgroundImageView?.isHidden = true
            highlightedBackgroundImageView?.image = nil
        }

        // Allows cells to animate changes in frame
        layoutIfNeeded()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView?.frame = contentView.frame
        highlightedBackgroundImageView?.frame = contentView.frame
        singlePixelLine?.frame = contentView.frame
        highlightedForegroundImageView.frame = contentView.bounds
    }
    
    override open var isHighlighted: Bool {
        didSet {
            switch highlightStyle {
            case .foreground:
                contentView.bringSubviewToFront(highlightedForegroundImageView)
                highlightedForegroundImageView.isHidden = !isHighlighted
            case .background:
                highlightedBackgroundImageView?.isHidden = !isHighlighted
            }
        }
    }
}

// MARK: - Enums

/**
 The cell styles supported by HarmonyLayout.
 */
@objc
public enum HarmonyCellStyle: Int {
    /// No border, transparent background.
    case none
    /// Rounded corners, white background, looks like a grouped table view.
    case grouped
    /// In a grouped table view, detached from neighboring cells by a narrow margin.
    case detached
    /// 1-point bottom border, no rounded corners, white background.
    case horizontalRule
    /// Plain rectangular white cells, with 1-point separators.
    case plain
}

/**
 The highlight styles supported by HarmonyLayout.
 */
@objc
public enum HarmonyHighlightStyle: Int {
    /// Hides or shows the highlighted background view based on the cell's highlight state.
    case background
    /// Hides or shows the highlighted foreground view based on the cell's highlight state.
    case foreground
}

@objc
public enum HarmonyTileSize: Int {
    case carouselSmall
    case carouselTall
    case mini
    case small
    case wide
    case tall
    case big
    case giant

    public var dimensions: (columns: Int, rows: Int) {
        switch self {
        case .carouselSmall: return (columns: 5, rows: 5)
        case .carouselTall:  return (columns: 5, rows: 8)
        case .mini:  return (columns: 4,  rows: 5)
        case .small: return (columns: 6,  rows: 5)
        case .wide:  return (columns: 12, rows: 5)
        case .tall:  return (columns: 6,  rows: 10)
        case .big:   return (columns: 12, rows: 10)
        case .giant: return (columns: 12, rows: 15)
        }
    }
}

@objc
public enum HarmonySectionStyle: Int {
    /// A vertical list of Harmony-styled cells.
    case list
    /// A vertical grid of Harmony-sized tiles.
    case grid
}

/**
 Where this cell appears in a group. This property is set by the layout regardless of the cell's
 style. When the style is .Grouped, this determines which corners are rounded.
 
 - Solo:   Lone cell in a section.
 - Top:    Top cell in a section.
 - Middle: Somewhere not at the top or bottom.
 - Bottom: It's at the bottom.
 */
public enum HarmonyCellPosition {
    case solo
    case top
    case middle
    case bottom
}
