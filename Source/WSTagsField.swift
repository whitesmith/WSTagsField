//
//  TagsField.swift
//  Pearland
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Pearland. All rights reserved.
//

import UIKit

public class TagsField: UIView {

    private static let HSPACE: CGFloat = 0.0
    private static let TEXT_FIELD_HSPACE: CGFloat = TagView.xPadding
    private static let VSPACE: CGFloat = 4.0
    private static let MINIMUM_TEXTFIELD_WIDTH: CGFloat = 56.0
    private static let STANDARD_ROW_HEIGHT: CGFloat = 25.0
    private static let FIELD_MARGIN_X: CGFloat = TagView.xPadding

    private let textField = BackspaceDetectingTextField()

    public override var tintColor: UIColor! {
        didSet {
            tagViews.forEach() { item in
                item.tintColor = self.tintColor
            }
        }
    }

    public var textColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.textColor = self.textColor
            }
        }
    }

    public var selectedColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.selectedColor = self.selectedColor
            }
        }
    }

    public var selectedTextColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.selectedTextColor = self.selectedTextColor
            }
        }
    }

    public var delimiter: String? {
        didSet {
            tagViews.forEach() { item in
                item.displayDelimiter = self.delimiter ?? ""
            }
        }
    }

    public var fieldTextColor: UIColor? {
        didSet {
            textField.textColor = textColor
        }
    }

    public var placeholder: String = "Tags" {
        didSet {
            updatePlaceholderTextVisibility()
        }
    }

    public var font: UIFont? {
        didSet {
            textField.font = font
            tagViews.forEach() { item in
                item.font = self.font
            }
        }
    }

    public var padding: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 16.0) {
        didSet {
            repositionViews()
        }
    }

    public var spaceBetweenTags: CGFloat = 2.0 {
        didSet {
            repositionViews()
        }
    }

    public private(set) var tags = [Tag]()
    private var tagViews = [TagView]()
    private var intrinsicContentHeight: CGFloat = 0.0


    // MARK: - Events

    /// Called when the text field begins editing
    public var onDidEndEditing: ((TagsField) -> Void)?

    /// Called when the text field ends editing
    public var onDidBeginEditing: ((TagsField) -> Void)?

    /// Called when the text field should return
    public var onShouldReturn: ((TagsField) -> Bool)?

    /// Called when the text field text has changed. You should update your autocompleting UI based on the text supplied.
    public var onDidChangeText: ((TagsField, text: String?) -> Void)?

    /// Called when a tag has been added. You should use this opportunity to update your local list of selected items.
    public var onDidAddTag: ((TagsField, tag: Tag) -> Void)?

    /// Called when a tag has been removed. You should use this opportunity to update your local list of selected items.
    public var onDidRemoveTag: ((TagsField, tag: Tag) -> Void)?

    /**
     * Called when the user attempts to press the Return key with text partially typed.
     * @return A Tag for a match (typically the first item in the matching results),
     * or nil if the text shouldn't be accepted.
     */
    public var onVerifyTag: ((TagsField, text: String) -> Bool)?

    /**
     * Called when the view has updated its own height. If you are
     * not using Autolayout, you should use this method to update the
     * frames to make sure the tag view still fits.
     */
    public var onDidChangeHeightTo: ((TagsField, height: CGFloat) -> Void)?

    // MARK: -

    public override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    private func internalInit() {
        textColor = .whiteColor()
        selectedColor = .grayColor()
        selectedTextColor = .blackColor()

        textField.backgroundColor = .clearColor()
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.autocapitalizationType = UITextAutocapitalizationType.None
        textField.delegate = self
        textField.font = font
        textField.textColor = fieldTextColor
        addSubview(textField)

        textField.onDeleteBackwards = {
            if self.textField.text?.isEmpty ?? true, let tagView = self.tagViews.last {
                self.selectTagView(tagView, animated: true)
                self.textField.resignFirstResponder()
            }
        }

        textField.addTarget(self, action: #selector(onTextFieldDidChange(_:)), forControlEvents:UIControlEvents.EditingChanged)

        intrinsicContentHeight = TagsField.STANDARD_ROW_HEIGHT
        repositionViews()
    }

    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: max(45, self.intrinsicContentHeight))
    }

    private func repositionViews() {
        let rightBoundary: CGFloat = CGRectGetWidth(self.bounds) - padding.right
        let firstLineRightBoundary: CGFloat = rightBoundary
        var curX: CGFloat = padding.left
        var curY: CGFloat = padding.top
        var totalHeight: CGFloat = TagsField.STANDARD_ROW_HEIGHT
        var isOnFirstLine = true

        // Position Tag views
        var tagRect = CGRect.null
        for tagView in tagViews {
            tagRect = tagView.frame

            let tagBoundary = isOnFirstLine ? firstLineRightBoundary : rightBoundary
            if curX + CGRectGetWidth(tagRect) > tagBoundary {
                // Need a new line
                curX = padding.left
                curY += TagsField.STANDARD_ROW_HEIGHT + TagsField.VSPACE
                totalHeight += TagsField.STANDARD_ROW_HEIGHT
                isOnFirstLine = false
            }

            tagRect.origin.x = curX
            // Center our tagView vertically within STANDARD_ROW_HEIGHT
            tagRect.origin.y = curY + ((TagsField.STANDARD_ROW_HEIGHT - CGRectGetHeight(tagRect))/2.0)
            tagView.frame = tagRect

            curX = CGRectGetMaxX(tagRect) + TagsField.HSPACE + self.spaceBetweenTags
        }

        // Always indent TextField by a little bit
        curX += TagsField.TEXT_FIELD_HSPACE - self.spaceBetweenTags
        let textBoundary: CGFloat = isOnFirstLine ? firstLineRightBoundary : rightBoundary
        var availableWidthForTextField: CGFloat = textBoundary - curX
        if availableWidthForTextField < TagsField.MINIMUM_TEXTFIELD_WIDTH {
            isOnFirstLine = false
            // If in the future we add more UI elements below the tags,
            // isOnFirstLine will be useful, and this calculation is important.
            // So leaving it set here, and marking the warning to ignore it
            curX = padding.left + TagsField.TEXT_FIELD_HSPACE
            curY += TagsField.STANDARD_ROW_HEIGHT + TagsField.VSPACE
            totalHeight += TagsField.STANDARD_ROW_HEIGHT
            // Adjust the width
            availableWidthForTextField = rightBoundary - curX
        }

        var textFieldRect: CGRect = self.textField.frame
        textFieldRect.origin.x = curX
        textFieldRect.origin.y = curY
        textFieldRect.size.width = availableWidthForTextField
        textFieldRect.size.height = TagsField.STANDARD_ROW_HEIGHT
        self.textField.frame = textFieldRect

        let oldContentHeight: CGFloat = self.intrinsicContentHeight
        intrinsicContentHeight = max(totalHeight, CGRectGetMaxY(textFieldRect) + padding.bottom)
        invalidateIntrinsicContentSize()

        if oldContentHeight != self.intrinsicContentHeight {
            let newContentHeight = intrinsicContentSize().height
            if let didChangeHeightToEvent = self.onDidChangeHeightTo {
                didChangeHeightToEvent(self, height: newContentHeight)
            }
            frame.size.height = newContentHeight
        }
        else {
            frame.size.height = oldContentHeight
        }
        setNeedsDisplay()
    }

    private func updatePlaceholderTextVisibility() {
        if tags.count > 0 {
            textField.placeholder = nil
        }
        else {
            textField.placeholder = self.placeholder
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        repositionViews()
    }

    public var isEditing: Bool {
        return self.textField.editing
    }


    public func beginEditing() {
        self.textField.becomeFirstResponder()
        self.unselectAllTagViewsAnimated(false)
    }

    public func endEditing() {
        // NOTE: We used to check if .isFirstResponder and then resign first responder, but sometimes we noticed that it would be the first responder, but still return isFirstResponder=NO. So always attempt to resign without checking.
        self.textField.resignFirstResponder()
    }


    // MARK: - Adding / Removing Tags

    public func addTags(tags: [String]) {
        addTags(tags.map{ Tag(displayText: $0) })
    }

    public func addTags(tags: [Tag]) {
        tags.forEach() { addTag($0) }
    }

    public func addTag(tag: Tag) {
        if self.tags.contains(tag) {
            return
        }
        self.tags.append(tag)

        let tagView = TagView(tag: tag)
        tagView.font = self.font
        tagView.tintColor = self.tintColor
        tagView.textColor = self.textColor
        tagView.selectedColor = self.selectedColor
        tagView.selectedTextColor = self.selectedTextColor
        tagView.displayDelimiter = self.delimiter ?? ""

        tagView.onDidRequestSelection = { tagView in
            self.selectTagView(tagView, animated: true)
        }

        tagView.onDidRequestDelete = { tagView, replacementText in
            // First, refocus the text field
            self.textField.becomeFirstResponder()
            if (replacementText?.isEmpty ?? false) == false {
                self.textField.text = replacementText
            }
            // Then remove the view from our data
            if let index = self.tagViews.indexOf(tagView) {
                self.removeTagAtIndex(index)
            }
        }
        
        self.tagViews.append(tagView)
        addSubview(tagView)

        self.textField.text = ""
        if let didAddTagEvent = onDidAddTag {
            didAddTagEvent(self, tag: tag)
        }

        // Clearing text programmatically doesn't call this automatically
        onTextFieldDidChange(self.textField)

        updatePlaceholderTextVisibility()
        repositionViews()
    }

    public func removeTag(tag: Tag) {
        if let index = self.tags.indexOf(tag) {
            removeTagAtIndex(index)
        }
    }

    public func removeTagAtIndex(index: Int) {
        if index < 0 || index >= self.tags.count {
            return
        }
        let tagView = self.tagViews[index]
        tagView.removeFromSuperview()
        self.tagViews.removeAtIndex(index)

        let removedTag = self.tags[index]
        self.tags.removeAtIndex(index)
        if let didRemoveTagEvent = onDidRemoveTag {
            didRemoveTagEvent(self, tag: removedTag)
        }
        updatePlaceholderTextVisibility()
        repositionViews()
    }

    public func removeTags() {
        self.tags.enumerate().reverse().forEach { index, tag in
            removeTagAtIndex(index)
        }
    }

    public func tokenizeTextFieldText() -> Tag? {
        let text = self.textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        if text.isEmpty == false && (onVerifyTag?(self, text: text) ?? true) {
            let tag = Tag(displayText: text)
            addTag(tag)
            self.textField.text = ""
            onTextFieldDidChange(self.textField)
            return tag
        }
        return nil
    }


    // MARK: - Actions

    public func onTextFieldDidChange(sender: AnyObject) {
        if let didChangeTextEvent = onDidChangeText {
            didChangeTextEvent(self, text: textField.text)
        }
    }


    // MARK: - Tag selection

    public func selectTagView(tagView: TagView, animated: Bool) {
        tagView.selected = true
        tagViews.forEach() { item in
            if item != tagView {
                item.selected = false
            }
        }
    }

    public func unselectAllTagViewsAnimated(animated: Bool) {
        tagViews.forEach() { item in
            item.selected = false
        }
    }

}

public func ==(lhs: UITextField, rhs: TagsField) -> Bool {
    return lhs == rhs.textField
}

extension TagsField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(textField: UITextField) {
        if let didBeginEditingEvent = onDidBeginEditing {
            didBeginEditingEvent(self)
        }
        unselectAllTagViewsAnimated(true)
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        if let didEndEditingEvent = onDidEndEditing {
            didEndEditingEvent(self)
        }
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        tokenizeTextFieldText()
        var shouldDoDefaultBehavior = false
        if let shouldReturnEvent = onShouldReturn {
            shouldDoDefaultBehavior = shouldReturnEvent(self)
        }
        return shouldDoDefaultBehavior
    }

    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }

}

private protocol BackspaceDetectingTextFieldDelegate: UITextFieldDelegate {
    /// Notify whenever the backspace key is pressed
    func textFieldDidDeleteBackwards(textField: UITextField)
}

private class BackspaceDetectingTextField: UITextField {

    var onDeleteBackwards: Optional<()->()>

    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func deleteBackward() {
        if let deleteBackwardsEvent = onDeleteBackwards {
            deleteBackwardsEvent()
        }
        // Call super afterwards. The `text` property will return text prior to the delete.
        super.deleteBackward()
    }
    
}
