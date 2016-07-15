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
    let testButton = UIButton(type: .System)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .redColor()
        tagsField.placeholder = "Enter a tag"
        tagsField.backgroundColor = .whiteColor()
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
        testButton.backgroundColor = .whiteColor()
        testButton.setTitle("Test", forState: .Normal)
        view.addSubview(testButton)
        testButton.addTarget(self, action: #selector(didTouchTestButton), forControlEvents: .TouchUpInside)
    }

    func didTouchTestButton(sender: AnyObject) {
        tagsField.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tagsField.spaceBetweenTags = 10.0
        tagsField.font = .systemFontOfSize(12.0)
        tagsField.tintColor = .greenColor()
        tagsField.textColor = .blackColor()
        tagsField.fieldTextColor = .blueColor()
        tagsField.selectedColor = .blackColor()
        tagsField.selectedTextColor = .redColor()
        tagsField.delimiter = ","
        print(tagsField.tags)
    }

    override func viewDidAppear(animated: Bool) {
        if tagsField.isEditing == false {
            tagsField.beginEditing()
        }
        super.viewDidAppear(animated)
    }

}
