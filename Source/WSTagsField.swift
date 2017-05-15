//
//  WSTagsField.swift
//  Whitesmith
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit

open class WSTagsField: UIView {

    fileprivate static let HSPACE: CGFloat = 0.0
    fileprivate static let TEXT_FIELD_HSPACE: CGFloat = WSTagView.xPadding
    fileprivate static let VSPACE: CGFloat = 4.0
    fileprivate static let MINIMUM_TEXTFIELD_WIDTH: CGFloat = 56.0
    fileprivate static let STANDARD_ROW_HEIGHT: CGFloat = 25.0
    fileprivate static let FIELD_MARGIN_X: CGFloat = WSTagView.xPadding

    fileprivate let textField = BackspaceDetectingTextField()

    open override var tintColor: UIColor! {
        didSet {
            tagViews.forEach() { item in
                item.tintColor = self.tintColor
            }
        }
    }

    open var textColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.textColor = self.textColor
            }
        }
    }

    open var selectedColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.selectedColor = self.selectedColor
            }
        }
    }

    open var selectedTextColor: UIColor? {
        didSet {
            tagViews.forEach() { item in
                item.selectedTextColor = self.selectedTextColor
            }
        }
    }

    open var delimiter: String? {
        didSet {
            tagViews.forEach() { item in
                item.displayDelimiter = self.delimiter ?? ""
            }
        }
    }

    open var fieldTextColor: UIColor? {
        didSet {
            textField.textColor = fieldTextColor
        }
    }

    open var placeholder: String = "Tags" {
        didSet {
            updatePlaceholderTextVisibility()
        }
    }

    open var font: UIFont? {
        didSet {
            textField.font = font
            tagViews.forEach() { item in
                item.font = self.font
            }
        }
    }

    open var readOnly: Bool = false {
        didSet {
            unselectAllTagViewsAnimated()
            textField.isEnabled = !readOnly
            repositionViews()
        }
    }

    open var padding: UIEdgeInsets = UIEdgeInsets(top: 10.0, left: 8.0, bottom: 10.0, right: 8.0) {
        didSet {
            repositionViews()
        }
    }

    open var spaceBetweenTags: CGFloat = 2.0 {
        didSet {
            repositionViews()
        }
    }
    
    public var keyboardType: UIKeyboardType {
        get {
            return textField.keyboardType
        }
        
        set {
            textField.keyboardType = newValue
        }
    }
    
    public var returnKeyType: UIReturnKeyType {
        get {
            return textField.returnKeyType
        }
        set {
            textField.returnKeyType = newValue
        }
    }
  
    public var spellCheckingType: UITextSpellCheckingType {
        get {
            return textField.spellCheckingType
        }
        set {
            textField.spellCheckingType = newValue
        }
    }
  
    public var autocapitalizationType: UITextAutocapitalizationType {
        get {
            return textField.autocapitalizationType
        }
        set {
            textField.autocapitalizationType = newValue
        }
    }
  
    public var autocorrectionType: UITextAutocorrectionType {
        get {
            return textField.autocorrectionType
        }
        set {
            textField.autocorrectionType = newValue
        }
    }
  
    public var enablesReturnKeyAutomatically: Bool {
        get {
            return textField.enablesReturnKeyAutomatically
        }
        set {
            textField.enablesReturnKeyAutomatically = newValue
        }
    }
  
    public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
  
    @available(iOS, unavailable)
    override open var inputAccessoryView: UIView? {
        get {
            return super.inputAccessoryView
        }
    }

    open var inputFieldAccessoryView: UIView? {
        get {
            return textField.inputAccessoryView
        }
        set {
            textField.inputAccessoryView = newValue
        }
    }

    open fileprivate(set) var tags = [WSTag]()
    internal var tagViews = [WSTagView]()
    fileprivate var intrinsicContentHeight: CGFloat = 0.0


    // MARK: - Events

    /// Called when the text field begins editing.
    open var onDidEndEditing: ((WSTagsField) -> Void)?

    /// Called when the text field ends editing.
    open var onDidBeginEditing: ((WSTagsField) -> Void)?

    /// Called when the text field should return.
    open var onShouldReturn: ((WSTagsField) -> Bool)?

    /// Called when the text field text has changed. You should update your autocompleting UI based on the text supplied.
    open var onDidChangeText: ((WSTagsField, _ text: String?) -> Void)?

    /// Called when a tag has been added. You should use this opportunity to update your local list of selected items.
    open var onDidAddTag: ((WSTagsField, _ tag: WSTag) -> Void)?

    /// Called when a tag has been removed. You should use this opportunity to update your local list of selected items.
    open var onDidRemoveTag: ((WSTagsField, _ tag: WSTag) -> Void)?

    /// Called when a tag has been selected.
    open var onDidSelectTagView: ((WSTagsField, _ tag: WSTagView) -> Void)?

    /// Called when a tag has been unselected.
    open var onDidUnselectTagView: ((WSTagsField, _ tag: WSTagView) -> Void)?

    /**
     * Called when the user attempts to press the Return key with text partially typed.
     * @return A Tag for a match (typically the first item in the matching results),
     * or nil if the text shouldn't be accepted.
     */
    open var onVerifyTag: ((WSTagsField, _ text: String) -> Bool)?

    /**
     * Called when the view has updated its own height. If you are
     * not using Autolayout, you should use this method to update the
     * frames to make sure the tag view still fits.
     */
    open var onDidChangeHeightTo: ((WSTagsField, _ height: CGFloat) -> Void)?

    // MARK: -

    public override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    fileprivate func internalInit() {
        textColor = .white
        selectedColor = .gray
        selectedTextColor = .black

        clipsToBounds = true

        textField.backgroundColor = .clear
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.spellCheckingType = .no
        textField.delegate = self
        textField.font = font
        textField.textColor = fieldTextColor
        addSubview(textField)

        textField.onDeleteBackwards = { [weak self] in
            if self?.readOnly ?? true {
                return
            }
            if self?.textField.text?.isEmpty ?? true, let tagView = self?.tagViews.last {
                self?.selectTagView(tagView, animated: true)
                self?.textField.resignFirstResponder()
            }
        }

        textField.addTarget(self, action: #selector(onTextFieldDidChange(_:)), for:UIControlEvents.editingChanged)

        intrinsicContentHeight = WSTagsField.STANDARD_ROW_HEIGHT
        repositionViews()
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.size.width - padding.left - padding.right, height: max(45, self.intrinsicContentHeight))
    }

    fileprivate func repositionViews() {
        let rightBoundary: CGFloat = self.bounds.width - padding.right
        let firstLineRightBoundary: CGFloat = rightBoundary
        var curX: CGFloat = padding.left
        var curY: CGFloat = padding.top
        var totalHeight: CGFloat = WSTagsField.STANDARD_ROW_HEIGHT
        var isOnFirstLine = true

        // Position Tag views
        var tagRect = CGRect.null
        for tagView in tagViews {
            tagRect = CGRect(origin: CGPoint.zero, size: tagView.sizeToFit(self.intrinsicContentSize))

            let tagBoundary = isOnFirstLine ? firstLineRightBoundary : rightBoundary
            if curX + tagRect.width > tagBoundary {
                // Need a new line
                curX = padding.left
                curY += WSTagsField.STANDARD_ROW_HEIGHT + WSTagsField.VSPACE
                totalHeight += WSTagsField.STANDARD_ROW_HEIGHT
                isOnFirstLine = false
            }

            tagRect.origin.x = curX
            // Center our tagView vertically within STANDARD_ROW_HEIGHT
            tagRect.origin.y = curY + ((WSTagsField.STANDARD_ROW_HEIGHT - tagRect.height)/2.0)
            tagView.frame = tagRect
            tagView.setNeedsLayout()

            curX = tagRect.maxX + WSTagsField.HSPACE + self.spaceBetweenTags
        }

        // Always indent TextField by a little bit
        curX += max(0, WSTagsField.TEXT_FIELD_HSPACE - self.spaceBetweenTags)
        let textBoundary: CGFloat = isOnFirstLine ? firstLineRightBoundary : rightBoundary
        var availableWidthForTextField: CGFloat = textBoundary - curX
        if availableWidthForTextField < WSTagsField.MINIMUM_TEXTFIELD_WIDTH {
            isOnFirstLine = false
            // If in the future we add more UI elements below the tags,
            // isOnFirstLine will be useful, and this calculation is important.
            // So leaving it set here, and marking the warning to ignore it
            curX = padding.left + WSTagsField.TEXT_FIELD_HSPACE
            curY += WSTagsField.STANDARD_ROW_HEIGHT + WSTagsField.VSPACE
            totalHeight += WSTagsField.STANDARD_ROW_HEIGHT
            // Adjust the width
            availableWidthForTextField = rightBoundary - curX
        }

        var textFieldRect = CGRect.zero
        textFieldRect.origin.y = curY
        textFieldRect.size.height = WSTagsField.STANDARD_ROW_HEIGHT
        if textField.isEnabled {
            textFieldRect.origin.x = curX
            textFieldRect.size.width = availableWidthForTextField
            textField.isHidden = false
        }
        else {
            textField.isHidden = true
        }
        self.textField.frame = textFieldRect

        let oldContentHeight: CGFloat = self.intrinsicContentHeight
        intrinsicContentHeight = max(totalHeight, textFieldRect.maxY + padding.bottom)
        invalidateIntrinsicContentSize()

        if oldContentHeight != self.intrinsicContentHeight {
            let newContentHeight = intrinsicContentSize.height
            if let didChangeHeightToEvent = self.onDidChangeHeightTo {
                didChangeHeightToEvent(self, newContentHeight)
            }
            if constraints.isEmpty {
                frame.size.height = newContentHeight
            }
        }
        else if frame.size.height != oldContentHeight {
            if constraints.isEmpty {
                frame.size.height = oldContentHeight
            }
        }
        setNeedsDisplay()
    }

    fileprivate func updatePlaceholderTextVisibility() {
        if tags.count > 0 {
            textField.placeholder = nil
        }
        else {
            textField.placeholder = self.placeholder
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        tagViews.forEach {
            $0.setNeedsLayout()
        }
        repositionViews()
    }

    /// Take the text inside of the field and make it a Tag.
    open func acceptCurrentTextAsTag() {
        if let currentText = tokenizeTextFieldText() , (self.textField.text?.isEmpty ?? true) == false {
            self.addTag(currentText)
        }
    }
    
    open var isEditing: Bool {
        return self.textField.isEditing
    }

    open func beginEditing() {
        self.textField.becomeFirstResponder()
        self.unselectAllTagViewsAnimated(false)
    }

    open func endEditing() {
        // NOTE: We used to check if .isFirstResponder and then resign first responder, but sometimes we noticed that it would be the first responder, but still return isFirstResponder=NO. So always attempt to resign without checking.
        self.textField.resignFirstResponder()
    }


    // MARK: - Adding / Removing Tags

    open func addTags(_ tags: [String]) {
        tags.forEach() { addTag($0) }
    }

    open func addTags(_ tags: [WSTag]) {
        tags.forEach() { addTag($0) }
    }

    open func addTag(_ tag: String) {
        addTag(WSTag(tag))
    }

    open func addTag(_ tag: WSTag) {
        if self.tags.contains(tag) {
            return
        }
        self.tags.append(tag)

        let tagView = WSTagView(tag: tag)
        tagView.font = self.font
        tagView.tintColor = self.tintColor
        tagView.textColor = self.textColor
        tagView.selectedColor = self.selectedColor
        tagView.selectedTextColor = self.selectedTextColor
        tagView.displayDelimiter = self.delimiter ?? ""

        tagView.onDidRequestSelection = { [weak self] tagView in
            self?.selectTagView(tagView, animated: true)
        }

        tagView.onDidRequestDelete = { [weak self] tagView, replacementText in
            // First, refocus the text field
            self?.textField.becomeFirstResponder()
            if (replacementText?.isEmpty ?? false) == false {
                self?.textField.text = replacementText
            }
            // Then remove the view from our data
            if let index = self?.tagViews.index(of: tagView) {
                self?.removeTagAtIndex(index)
            }
        }

        tagView.onDidInputText = { [weak self] tagView, text in
            if text == "\n" {
                self?.selectNextTag()
            }
            else {
                self?.textField.becomeFirstResponder()
                self?.textField.text = text
            }
        }
        
        self.tagViews.append(tagView)
        addSubview(tagView)

        self.textField.text = ""
        if let didAddTagEvent = onDidAddTag {
            didAddTagEvent(self, tag)
        }

        // Clearing text programmatically doesn't call this automatically
        onTextFieldDidChange(self.textField)

        updatePlaceholderTextVisibility()
        repositionViews()
    }

    open func removeTag(_ tag: String) {
        removeTag(WSTag(tag))
    }

    open func removeTag(_ tag: WSTag) {
        if let index = self.tags.index(of: tag) {
            removeTagAtIndex(index)
        }
    }

    open func removeTagAtIndex(_ index: Int) {
        if index < 0 || index >= self.tags.count {
            return
        }
        let tagView = self.tagViews[index]
        tagView.removeFromSuperview()
        self.tagViews.remove(at: index)

        let removedTag = self.tags[index]
        self.tags.remove(at: index)
        if let didRemoveTagEvent = onDidRemoveTag {
            didRemoveTagEvent(self, removedTag)
        }
        updatePlaceholderTextVisibility()
        repositionViews()
    }

    open func removeTags() {
        self.tags.enumerated().reversed().forEach { index, tag in
            removeTagAtIndex(index)
        }
    }

    @discardableResult
    open func tokenizeTextFieldText() -> WSTag? {
        let text = self.textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        if text.isEmpty == false && (onVerifyTag?(self, text) ?? true) {
            let tag = WSTag(text)
            addTag(tag)
            self.textField.text = ""
            onTextFieldDidChange(self.textField)
            return tag
        }
        return nil
    }


    // MARK: - Actions

    open func onTextFieldDidChange(_ sender: AnyObject) {
        if let didChangeTextEvent = onDidChangeText {
            didChangeTextEvent(self, textField.text)
        }
    }


    // MARK: - Tag selection

    open func selectNextTag() {
        guard let selectedIndex = tagViews.index(where: { $0.selected }) else {
            return
        }
        let nextIndex = tagViews.index(after: selectedIndex)
        if nextIndex < tagViews.count {
            tagViews[selectedIndex].selected = false
            tagViews[nextIndex].selected = true
        }
    }

    open func selectPrevTag() {
        guard let selectedIndex = tagViews.index(where: { $0.selected }) else {
            return
        }
        let prevIndex = tagViews.index(before: selectedIndex)
        if prevIndex >= 0 {
            tagViews[selectedIndex].selected = false
            tagViews[prevIndex].selected = true
        }
    }

    open func selectTagView(_ tagView: WSTagView, animated: Bool = false) {
        if self.readOnly {
            return
        }
        tagView.selected = true
        tagViews.forEach() { item in
            if item != tagView {
                item.selected = false
                onDidUnselectTagView?(self, item)
            }
        }
        onDidSelectTagView?(self, tagView)
    }

    open func unselectAllTagViewsAnimated(_ animated: Bool = false) {
        tagViews.forEach() { item in
            item.selected = false
            onDidUnselectTagView?(self, item)
        }
    }

}

public func ==(lhs: UITextField, rhs: WSTagsField) -> Bool {
    return lhs == rhs.textField
}

extension WSTagsField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let didBeginEditingEvent = onDidBeginEditing {
            didBeginEditingEvent(self)
        }
        unselectAllTagViewsAnimated(true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let didEndEditingEvent = onDidEndEditing {
            didEndEditingEvent(self)
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tokenizeTextFieldText()
        var shouldDoDefaultBehavior = false
        if let shouldReturnEvent = onShouldReturn {
            shouldDoDefaultBehavior = shouldReturnEvent(self)
        }
        return shouldDoDefaultBehavior
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

}

private protocol BackspaceDetectingTextFieldDelegate: UITextFieldDelegate {
    /// Notify whenever the backspace key is pressed
    func textFieldDidDeleteBackwards(_ textField: UITextField)
}

private class BackspaceDetectingTextField: UITextField {

    var onDeleteBackwards: Optional<()->()>

    init() {
        super.init(frame: CGRect.zero)
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
