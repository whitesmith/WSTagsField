# WSTagsField

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WSTagsField.svg)](https://cocoapods.org/pods/WSTagsField)
[![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com/ios/)
[![Build Status](https://app.bitrise.io/app/059bc89743c769dc/status.svg?token=Wu0zdJtTsCQlVFSG1XuGIw&branch=master)]()
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://opensource.org/licenses/MIT)

An iOS text field that represents tags, hashtags, tokens in general.

![WSTagsField](http://i.giphy.com/3o72F8JCGkjrF4Lwvm.gif)

## Usage

``` swift
let tagsField = WSTagsField()
tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
tagsField.spaceBetweenLines = 5.0
tagsField.spaceBetweenTags = 10.0
tagsField.font = .systemFont(ofSize: 12.0)
tagsField.backgroundColor = .white
tagsField.tintColor = .green
tagsField.textColor = .black
tagsField.fieldTextColor = .blue
tagsField.selectedColor = .black
tagsField.selectedTextColor = .red
tagsField.delimiter = ","
tagsField.isDelimiterVisible = true
tagsField.placeholderColor = .green
tagsField.placeholderAlwaysVisible = true
tagsField.keyboardAppearance = .dark
tagsField.returnKeyType = .next
tagsField.acceptTagOption = .space
tagsField.shouldTokenizeAfterResigningFirstResponder = true

// Events
tagsField.onDidAddTag = { field, tag in
    print("DidAddTag", tag.text)
}

tagsField.onDidRemoveTag = { field, tag in
    print("DidRemoveTag", tag.text)
}

tagsField.onDidChangeText = { _, text in
    print("DidChangeText")
}

tagsField.onDidChangeHeightTo = { _, height in
    print("HeightTo", height)
}

tagsField.onValidateTag = { tag, tags in
    // custom validations, called before tag is added to tags list
    return tag.text != "#" && !tags.contains(where: { $0.text.uppercased() == tag.text.uppercased() })
}

print("List of Tags Strings:", tagsField.tags.map({$0.text}))
```

## Installation

#### <img src="https://cloud.githubusercontent.com/assets/432536/5252404/443d64f4-7952-11e4-9d26-fc5cc664cb61.png" width="24" height="24"> [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

To install it, simply add the following line to your **Cartfile**:

```ruby
github "whitesmith/WSTagsField"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

#### <img src="https://raw.githubusercontent.com/ricardopereira/resources/master/img/cocoapods.png" width="24" height="24"> [CocoaPods]

[CocoaPods]: http://cocoapods.org

To install it, simply add the following line to your **Podfile**:

```ruby
pod "WSTagsField"
```

Then run `pod install` with CocoaPods 1.8.0 or newer.

### Swift Package Manager

Using **Xcode 11**, just go to _"File" > "Swift Packages" > "Add Package Dependency..."_ and use this repository: `https://github.com/whitesmith/WSTagsField`.

### Manually

Download all the source files and drop them into your project.

## Requirements

* iOS 9.0+
* Xcode 11 (Swift 5.1)

# Contributing

The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/whitesmith/WSTagsField/issues/new) if you find bugs or have questions. :octocat:

# Credits
![Whitesmith](http://i.imgur.com/Si2l3kd.png)

This project was inspired by [CLTokenInputView](https://github.com/clusterinc/CLTokenInputView).
