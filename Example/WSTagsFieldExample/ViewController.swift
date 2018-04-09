//
//  ViewController.swift
//  WSTagsFieldExample
//
//  Created by Ricardo Pereira on 04/07/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit
import WSTagsField

class ViewController: UIViewController {

    fileprivate let tagsField = WSTagsField()

    @IBOutlet fileprivate weak var tagsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)

        //tagsField.translatesAutoresizingMaskIntoConstraints = false
        //tagsField.heightAnchor.constraint(equalToConstant: 150).isActive = true

        tagsField.tagCornerRadius = 3.0
        tagsField.lineSpace = 10
        tagsField.spaceBetweenTags = 10

        //tagsField.numberOfLines = 3
        //tagsField.maxHeight = 100.0

        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding

        tagsField.placeholder = "Enter a tag"
        tagsField.placeholderColor = .red
        tagsField.placeholderAlwayVisible = true
        tagsField.backgroundColor = .lightGray
        tagsField.frame = tagsView.bounds
        tagsField.returnKeyType = .next
        tagsField.delimiter = " "

        textFieldEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsField.beginEditing()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }

    @IBAction func touchReadOnly(_ sender: UIButton) {
        tagsField.readOnly = !tagsField.readOnly
        sender.isSelected = tagsField.readOnly
    }

    @IBAction func touchChangeAppearance(_ sender: UIButton) {
        tagsField.layoutMargins = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        tagsField.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) //old padding
        tagsField.tagCornerRadius = 10.0
        tagsField.lineSpace = 2
        tagsField.spaceBetweenTags = 2
        tagsField.tintColor = .red
        tagsField.textColor = .blue
        tagsField.selectedColor = .yellow
        tagsField.selectedTextColor = .black
        tagsField.delimiter = ","
        tagsField.displayDelimiter = true
        tagsField.borderWidth = 2
        tagsField.borderColor = .blue
        tagsField.fieldTextColor = .green
        tagsField.placeholderColor = .green
        tagsField.placeholderAlwayVisible = false
    }

    @IBAction func touchAddRandomTags(_ sender: UIButton) {
        tagsField.addTag(NSUUID().uuidString)
        tagsField.addTag(NSUUID().uuidString)
        tagsField.addTag(NSUUID().uuidString)
        tagsField.addTag(NSUUID().uuidString)
    }

    @IBAction func touchTableView(_ sender: UIButton) {
        present(UINavigationController(rootViewController: TableViewController()), animated: true, completion: nil)
    }

}

extension ViewController {

    fileprivate func textFieldEvents() {
        tagsField.onDidAddTag = { _, _ in
            print("DidAddTag")
        }

        tagsField.onDidRemoveTag = { _, _ in
            print("DidRemoveTag")
        }

        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }

        tagsField.onDidBeginEditing = { _ in
            print("DidBeginEditing")
        }

        tagsField.onDidEndEditing = { _ in
            print("DidEndEditing")
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
    }

}
