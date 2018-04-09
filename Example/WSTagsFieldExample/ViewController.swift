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

        tagsField.placeholder = "Enter a tag"
        tagsField.placeholderColor = .red
        tagsField.backgroundColor = .lightGray
        tagsField.frame = tagsView.bounds
        tagsField.returnKeyType = .next
        tagsField.delimiter = " "
        tagsField.tagCornerRadius = 3.0
        tagsField.normalBackgroundColor = tagsField.tintColor

        tagsField.placeholderAlwayVisible = true
        tagsField.maxHeight = 100.0

        textFieldEventss()
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

    @IBAction func touchTest(_ sender: UIButton) {
        tagsField.addTag("test1")
        tagsField.addTag("test2")
        tagsField.addTag("test3")
        tagsField.addTag("test4")
    }

    @IBAction func touchTableView(_ sender: UIButton) {
        present(UINavigationController(rootViewController: TableViewController()), animated: true, completion: nil)
    }

}

extension ViewController {

    fileprivate func textFieldEventss() {
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
