//
//  WSTagView.swift
//  Whitesmith
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit

open class WSTagView: UIView {
    fileprivate let textLabel = UILabel()

    open var displayText: String = "" {
        didSet {
            updateLabelText()
            setNeedsDisplay()
        }
    }

    open var displayDelimiter: String = "" {
        didSet {
            updateLabelText()
            setNeedsDisplay()
        }
    }

    open var font: UIFont? {
        didSet {
            textLabel.font = font
            setNeedsDisplay()
        }
    }

    open var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            setNeedsDisplay()
        }
    }
    open var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    open var borderColor: UIColor? {
        didSet {
            if let borderColor = borderColor {
                self.layer.borderColor = borderColor.cgColor
                setNeedsDisplay()
            }
        }
    }

    open override var tintColor: UIColor! {
        didSet { updateContent(animated: false) }
    }

    /// Background color to be used for selected state.
    open var selectedColor: UIColor? {
        didSet { updateContent(animated: false) }
    }

    open var textColor: UIColor? {
        didSet { updateContent(animated: false) }
    }

    open var selectedTextColor: UIColor? {
        didSet { updateContent(animated: false) }
    }

    open var keyboardAppearanceType: UIKeyboardAppearance = .default

    internal var onDidRequestDelete: ((_ tagView: WSTagView, _ replacementText: String?) -> Void)?
    internal var onDidRequestSelection: ((_ tagView: WSTagView) -> Void)?
    internal var onDidInputText: ((_ tagView: WSTagView, _ text: String) -> Void)?

    open var selected: Bool = false {
        didSet {
            if selected && !isFirstResponder {
                _ = becomeFirstResponder()
            } else
            if !selected && isFirstResponder {
                _ = resignFirstResponder()
            }
            updateContent(animated: true)
        }
    }

    public init(tag: WSTag) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = tintColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true

        textColor = .white
        selectedColor = .gray
        selectedTextColor = .black

        textLabel.frame = CGRect(x: layoutMargins.left, y: layoutMargins.top, width: 0, height: 0)
        textLabel.font = font
        textLabel.textColor = .white
        textLabel.backgroundColor = .clear
        addSubview(textLabel)

        self.displayText = tag.text
        updateLabelText()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        addGestureRecognizer(tapRecognizer)
        setNeedsLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assert(false, "Not implemented")
    }

    fileprivate func updateColors() {
        self.backgroundColor = selected ? selectedColor : tintColor
        textLabel.textColor = selected ? selectedTextColor : textColor
    }

    internal func updateContent(animated: Bool) {
        guard animated else {
            updateColors()
            return
        }

        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                self?.updateColors()
                if self?.selected ?? false {
                    self?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }
            },
            completion: { [weak self] _ in
                if self?.selected ?? false {
                    UIView.animate(withDuration: 0.4) { [weak self] in
                        self?.transform = CGAffineTransform.identity
                    }
                }
            }
        )
    }

    // MARK: - Size Measurements
    open override var intrinsicContentSize: CGSize {
        let labelIntrinsicSize = textLabel.intrinsicContentSize
        return CGSize(width: labelIntrinsicSize.width + layoutMargins.left + layoutMargins.right,
                      height: labelIntrinsicSize.height + layoutMargins.top + layoutMargins.bottom)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let layoutMarginsHorizontal = layoutMargins.left + layoutMargins.right
        let layoutMarginsVertical = layoutMargins.top + layoutMargins.bottom
        let fittingSize = CGSize(width: size.width - layoutMarginsHorizontal,
                                 height: size.height - layoutMarginsVertical)
        let labelSize = textLabel.sizeThatFits(fittingSize)
        return CGSize(width: labelSize.width + layoutMarginsHorizontal,
                      height: labelSize.height + layoutMarginsVertical)
    }

    open func sizeToFit(_ size: CGSize) -> CGSize {
        if intrinsicContentSize.width > size.width {
            return CGSize(width: size.width,
                          height: intrinsicContentSize.height)
        }
        return intrinsicContentSize
    }

    // MARK: - Attributed Text
    fileprivate func updateLabelText() {
        // Unselected shows "[displayText]," and selected is "[displayText]"
        textLabel.text = displayText + displayDelimiter
        // Expand Label
        let intrinsicSize = self.intrinsicContentSize
        frame = CGRect(x: 0, y: 0, width: intrinsicSize.width, height: intrinsicSize.height)
    }

    // MARK: - Laying out
    open override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = UIEdgeInsetsInsetRect(bounds, layoutMargins)
        if frame.width == 0 || frame.height == 0 {
            frame.size = self.intrinsicContentSize
        }
    }

    // MARK: - First Responder (needed to capture keyboard)
    open override var canBecomeFirstResponder: Bool {
        return true
    }

    open override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        selected = true
        return didBecomeFirstResponder
    }

    open override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        selected = false
        return didResignFirstResponder
    }

    // MARK: - Gesture Recognizers
    @objc func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if selected {
            return
        }
        onDidRequestSelection?(self)
    }

}

extension WSTagView: UIKeyInput {

    public var hasText: Bool {
        return true
    }

    public func insertText(_ text: String) {
        onDidInputText?(self, text)
    }

    public func deleteBackward() {
        onDidRequestDelete?(self, nil)
    }

}

extension WSTagView: UITextInputTraits {

    // Solves an issue where autocorrect suggestions were being
    // offered when a tag is highlighted.
    public var autocorrectionType: UITextAutocorrectionType {
        get { return .no }
        set { }
    }

    public var keyboardAppearance: UIKeyboardAppearance {
        get { return keyboardAppearanceType }
        set { }
    }

}
