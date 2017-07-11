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
        
        tagsField.placeholder = "Enter a tag"
        tagsField.backgroundColor = .lightGray
        tagsField.frame = CGRect(x: 0, y: 44, width: 200, height: 44)
        tagsView.addSubview(tagsField)
        tagsField.frame = tagsView.bounds
        tagsField.returnKeyType = .next

        // Events
        tagsField.onDidAddTag = { _ in
            print("DidAddTag")
        }

        tagsField.onDidRemoveTag = { _ in
            print("DidRemoveTag")
        }

        tagsField.onDidChangeText = { _, text in

        }

        tagsField.onDidBeginEditing = { _ in
            print("DidBeginEditing")
        }

        tagsField.onDidEndEditing = { _ in
            print("DidEndEditing")
        }

        tagsField.onDidChangeHeightTo = { sender, height in
            print("HeightTo \(height)")
        }

        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }

        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        tagsField.frame = tagsView.bounds
    }

    @IBAction func touchReadOnly(_ sender: UIButton) {
        tagsField.readOnly = !tagsField.readOnly
        sender.isSelected = tagsField.readOnly
        
    }
    
    @IBAction func touchTest(_ sender: UIButton) {
        tagsField.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagsField.spaceBetweenTags = 10.0
        tagsField.font = .systemFont(ofSize: 12.0)
        tagsField.tintColor = .green
        tagsField.textColor = .black
        tagsField.fieldTextColor = .blue
        tagsField.selectedColor = .black
        tagsField.selectedTextColor = .red
        tagsField.delimiter = ","
        tagsField.returnKeyType = .go
        print(tagsField.tags)
        
        // Dealloc test
        let field = WSTagsField()
        field.addTag("test1")
        field.addTag("test2")
        field.addTag("test3")
        field.addTag("test4")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tagsField.isEditing == false {
            tagsField.beginEditing()
        }
        super.viewDidAppear(animated)
    }

}
