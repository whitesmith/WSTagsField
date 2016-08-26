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

    let tagsField = WSTagsField()
    let testButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tagsField.placeholder = "Enter a tag"
        tagsField.backgroundColor = .white
        tagsField.frame = CGRect(x: 0, y: 44, width: 200, height: 44)
        view.addSubview(tagsField)

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

        testButton.frame = CGRect(x: 0, y: 250, width: 100, height: 44)
        testButton.backgroundColor = .white
        testButton.setTitle("Test", for: UIControlState())
        view.addSubview(testButton)
        testButton.addTarget(self, action: #selector(didTouchTestButton), for: .touchUpInside)
    }

    func didTouchTestButton(_ sender: AnyObject) {
        tagsField.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagsField.spaceBetweenTags = 10.0
        tagsField.font = .systemFont(ofSize: 12.0)
        tagsField.tintColor = .green
        tagsField.textColor = .black
        tagsField.fieldTextColor = .blue
        tagsField.selectedColor = .black
        tagsField.selectedTextColor = .red
        tagsField.delimiter = ","
        print(tagsField.tags)
    }

    override func viewDidAppear(_ animated: Bool) {
        if tagsField.isEditing == false {
            tagsField.beginEditing()
        }
        super.viewDidAppear(animated)
    }

}
