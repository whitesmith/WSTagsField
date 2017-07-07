//
//  WSTagView.swift
//  Whitesmith
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit

open class WSTagView: UIView {

    internal static let xPadding: CGFloat = 6.0
    internal static let yPadding: CGFloat = 2.0

    fileprivate let backgroundLayer = CALayer()
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

    open override var tintColor: UIColor! {
        didSet {
            updateContent(animated: false)
        }
    }

    open var selectedColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }

    open var textColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }

    open var selectedTextColor: UIColor? {
        didSet {
            updateContent(animated: false)
        }
    }

    internal var onDidRequestDelete: Optional<(_ tagView: WSTagView, _ replacementText: String?)->()>
    internal var onDidRequestSelection: Optional<(_ tagView: WSTagView)->()>
    internal var onDidInputText: Optional<(_ tagView: WSTagView, _ text: String)->()>

    open var selected: Bool = false {
        didSet {
            if selected && !isFirstResponder {
                let _ = becomeFirstResponder()
            } else if !selected && isFirstResponder {
                let _ = resignFirstResponder()
            }
            updateContent(animated: true)
        }
    }


    public init(tag: WSTag) {
        super.init(frame: CGRect.zero)
        backgroundLayer.backgroundColor = tintColor.cgColor
        backgroundLayer.cornerRadius = 3.0
        backgroundLayer.masksToBounds = true
        layer.addSublayer(backgroundLayer)

        textColor = .white
        selectedColor = .gray
        selectedTextColor = .black

        textLabel.frame = CGRect(x: WSTagView.xPadding, y: WSTagView.yPadding, width: 0, height: 0)
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

    internal func updateContent(animated: Bool) {
        if animated {
            if selected {
                backgroundLayer.backgroundColor = selectedColor?.cgColor
                textLabel.textColor = selectedTextColor
            }
            UIView.animate(
                withDuration: 0.03,
                animations: {
                    self.backgroundLayer.backgroundColor = self.selected ? self.selectedColor?.cgColor : self.tintColor.cgColor
                    self.textLabel.textColor = self.selected ? self.selectedTextColor : self.textColor
                },
                completion: { finished in
                    if !self.selected {
                        self.backgroundLayer.backgroundColor = self.tintColor.cgColor
                        self.textLabel.textColor = self.textColor
                    }
                }
            )
        } else {
            backgroundLayer.backgroundColor = selected ? selectedColor?.cgColor : tintColor.cgColor
            textLabel.textColor = selected ? selectedTextColor : textColor
        }
    }


    // MARK: - Size Measurements

    open override var intrinsicContentSize: CGSize {
        let labelIntrinsicSize = textLabel.intrinsicContentSize
        return CGSize(width: labelIntrinsicSize.width + 2 * WSTagView.xPadding, height: labelIntrinsicSize.height + 2 * WSTagView.yPadding)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = CGSize(width: size.width - 2.0 * WSTagView.xPadding, height: size.height - 2.0 * WSTagView.yPadding)
        let labelSize = textLabel.sizeThatFits(fittingSize)
        return CGSize(width: labelSize.width + 2.0 * WSTagView.xPadding, height: labelSize.height + 2.0 * WSTagView.yPadding)
    }

    open func sizeToFit(_ size: CGSize) -> CGSize {
        if intrinsicContentSize.width > size.width {
            return CGSize(width: size.width, height: self.frame.size.height)
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
        backgroundLayer.frame = bounds
        textLabel.frame = bounds.insetBy(dx: WSTagView.xPadding, dy: WSTagView.yPadding)
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

    func handleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if let didRequestSelectionEvent = onDidRequestSelection {
            didRequestSelectionEvent(self)
        }
    }

}

extension WSTagView: UIKeyInput {

    public var hasText: Bool {
        return true
    }

    public func insertText(_ text: String) {
        if let didInputText = onDidInputText {
            didInputText(self, text)
        }
    }
    
    public func deleteBackward() {
        if let didRequestDeleteEvent = onDidRequestDelete {
            didRequestDeleteEvent(self, nil)
        }
    }
    
}

extension WSTagView: UITextInputTraits {
  
  // Solves an issue where autocorrect suggestions were being
  // offered when a tag is highlighted.
  public var autocorrectionType: UITextAutocorrectionType {
      get {
          return .no
      }
      set { }
  }
  
}
