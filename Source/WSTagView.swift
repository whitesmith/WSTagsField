//
//  TagView.swift
//  Pearland
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Pearland. All rights reserved.
//

import UIKit

public class TagView: UIView {

    internal static let xPadding: CGFloat = 6.0
    internal static let yPadding: CGFloat = 2.0

    private let backgroundLayer = CALayer()
    private let textLabel = UILabel()

    public var displayText: String = "" {
        didSet {
            updateLabelText()
            setNeedsDisplay()
        }
    }

    public var displayDelimiter: String = "" {
        didSet {
            updateLabelText()
            setNeedsDisplay()
        }
    }

    public var font: UIFont? {
        didSet {
            textLabel.font = font
            setNeedsDisplay()
        }
    }

    public override var tintColor: UIColor! {
        didSet {
            updateContent(animated: false)
        }
    }

    public var selectedColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }

    public var textColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }

    public var selectedTextColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }

    public var onDidRequestDelete: Optional<(tagView: TagView, replacementText: String?)->()>
    public var onDidRequestSelection: Optional<(tagView: TagView)->()>

    public var selected: Bool = false {
        didSet {
            if selected && !isFirstResponder() {
                becomeFirstResponder()
            } else if !selected && isFirstResponder() {
                resignFirstResponder()
            }
            updateContent(animated: true)
        }
    }


    public init(tag: Tag) {
        super.init(frame: CGRect.zero)
        backgroundLayer.backgroundColor = tintColor.CGColor
        backgroundLayer.cornerRadius = 3.0
        backgroundLayer.masksToBounds = true
        layer.addSublayer(backgroundLayer)

        textColor = .whiteColor()
        selectedColor = .grayColor()
        selectedTextColor = .blackColor()

        textLabel.frame = CGRect(x: TagView.xPadding, y: TagView.yPadding, width: 0, height: 0)
        textLabel.font = font
        textLabel.textColor = .whiteColor()
        textLabel.backgroundColor = .clearColor()
        addSubview(textLabel)

        self.displayText = tag.displayText
        updateLabelText()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        addGestureRecognizer(tapRecognizer)
        setNeedsLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assert(false, "Not implemented")
    }

    internal func updateContent(animated animated: Bool) {
        if animated {
            if selected {
                backgroundLayer.backgroundColor = selectedColor?.CGColor
                textLabel.textColor = selectedTextColor
            }
            UIView.animateWithDuration(
                0.03,
                animations: {
                    self.backgroundLayer.backgroundColor = self.selected ? self.selectedColor?.CGColor : self.tintColor.CGColor
                    self.textLabel.textColor = self.selected ? self.selectedTextColor : self.textColor
                },
                completion: { finished in
                    if !self.selected {
                        self.backgroundLayer.backgroundColor = self.tintColor.CGColor
                        self.textLabel.textColor = self.textColor
                    }
                }
            )
        } else {
            backgroundLayer.backgroundColor = selected ? selectedColor?.CGColor : tintColor.CGColor
            textLabel.textColor = selected ? selectedTextColor : textColor
        }
    }


    // MARK: - Size Measurements

    public override func intrinsicContentSize() -> CGSize {
        let labelIntrinsicSize = textLabel.intrinsicContentSize()
        return CGSize(width: labelIntrinsicSize.width + 2 * TagView.xPadding, height: labelIntrinsicSize.height + 2 * TagView.yPadding)
    }

    public override func sizeThatFits(size: CGSize) -> CGSize {
        let fittingSize = CGSize(width: size.width - 2.0 * TagView.xPadding, height: size.height - 2.0 * TagView.yPadding)
        let labelSize = textLabel.sizeThatFits(fittingSize)
        return CGSize(width: labelSize.width + 2.0 * TagView.xPadding, height: labelSize.height + 2.0 * TagView.yPadding)
    }


    // MARK: - Attributed Text

    private func updateLabelText() {
        // Unselected shows "[displayText]," and selected is "[displayText]"
        textLabel.text = displayText + displayDelimiter
        // Expand Label
        let intrinsicSize = intrinsicContentSize()
        frame = CGRect(x: 0, y: 0, width: intrinsicSize.width, height: intrinsicSize.height)
    }


    // MARK: - Laying out

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        var labelFrame = CGRectInset(bounds, TagView.xPadding, TagView.yPadding)
        labelFrame.size.width += TagView.xPadding * 2.0
        textLabel.frame = labelFrame
    }


    // MARK: - First Responder (needed to capture keyboard)

    public override func canBecomeFirstResponder() -> Bool {
        return true
    }

    public override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        selected = true
        return didBecomeFirstResponder
    }

    public override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        selected = false
        return didResignFirstResponder
    }


    // MARK: - Gesture Recognizers

    func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
        if let didRequestSelectionEvent = onDidRequestSelection {
            didRequestSelectionEvent(tagView: self)
        }
    }

}

extension TagView: UIKeyInput {

    public func hasText() -> Bool {
        return true
    }

    public func insertText(text: String) {
        if let didRequestDeleteEvent = onDidRequestDelete {
            didRequestDeleteEvent(tagView: self, replacementText: text)
        }
    }
    
    public func deleteBackward() {
        if let didRequestDeleteEvent = onDidRequestDelete {
            didRequestDeleteEvent(tagView: self, replacementText: nil)
        }
    }
    
}
