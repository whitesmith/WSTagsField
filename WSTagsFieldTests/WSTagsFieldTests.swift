//
//  WSTagsFieldTests.swift
//  WSTagsFieldTests
//
//  Created by Ricardo Pereira on 04/07/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import XCTest
@testable import WSTagsField

class WSTagsFieldTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddStringTag() {
        let tagsField = WSTagsField()
        tagsField.addTag("Whitesmith")
        tagsField.addTag("UIKit")
        tagsField.addTag("Whitesmith")
        XCTAssert(tagsField.tags.count == 2)
    }

    func testAddStringTags() {
        let tagsField = WSTagsField()
        tagsField.addTags(["Whitesmith", "iOS", "iOS", "UIKit"])
        XCTAssert(tagsField.tags.count == 3)
    }

    func testAddRemoveTag() {
        let tagsField = WSTagsField()
        tagsField.addTags(["Whitesmith", "iOS", "iOS", "UIKit"])
        tagsField.removeTag("Whitesmith")
        XCTAssert(tagsField.tags.count == 2)
    }

    func testAddRemoveAllTags() {
        let tagsField = WSTagsField()
        tagsField.addTags(["Whitesmith", "iOS", "iOS", "UIKit"])
        tagsField.removeTags()
        XCTAssert(tagsField.tags.isEmpty)
    }

    func testAddRemoveTagAtIndex() {
        let tagsField = WSTagsField()
        tagsField.addTags(["Whitesmith", "iOS", "iOS", "UIKit"])
        tagsField.removeTagAtIndex(0)
        XCTAssert(tagsField.tags.count == 2)
    }

    func testTagViews() {
        let tagsField = WSTagsField()
        tagsField.addTags(["Whitesmith", "iOS", "iOS", "UIKit"])
        XCTAssert(tagsField.tags.count == tagsField.tagViews.count)
    }

}
