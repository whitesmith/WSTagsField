# WSTagsField

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WSTagsField.svg)](https://cocoapods.org/pods/WSTagsField)
[![Swift 4.1](https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com/ios/)
[![Build Status](https://www.bitrise.io/app/059bc89743c769dc.svg?token=Wu0zdJtTsCQlVFSG1XuGIw&branch=master)](https://www.bitrise.io/app/059bc89743c769dc)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://opensource.org/licenses/MIT)

An iOS text field that represents different Tags.

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
tagsField.returnKeyType = .next
tagsField.acceptTagOption = .space

// Events
tagsField.onDidAddTag = { (_,_) in
    print("DidAddTag")
}

tagsField.onDidRemoveTag = { (_,_) in
    print("DidRemoveTag")
}

tagsField.onDidChangeText = { _, text in
    print("DidChangeText")
}

tagsField.onDidChangeHeightTo = { sender, height in
    print("HeightTo \(height)")
}

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

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 1.1.0 or newer.

#### <img src="https://raw.githubusercontent.com/ricardopereira/resources/master/img/swiftpm.png" width="24" height="24"> [SwiftPM]

[SwiftPM]: https://github.com/apple/swift-package-manager

If your version of Swift supports the SPM, you just need to add WSTagsField as a dependency in your `Package.swift`:

```swift
let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .Package(url: "https://github.com/whitesmith/WSTagsField.git", , versions: "2.0.0" ..< Version.max),
        ...
    ]
    ...
)
```

(**Note** that the Swift Package Manager is still in early design and development, for more information checkout its repository)

#### Manually

Download all the source files and drop them into your project.

## Requirements

* iOS 8.0+
* Xcode 9 (Swift 4.0)

# Contributing

The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/whitesmith/WSTagsField/issues/new) if you find bugs or have questions. :octocat:

# Credits
![Whitesmith](http://i.imgur.com/Si2l3kd.png)

This project was inspired by [CLTokenInputView](https://github.com/clusterinc/CLTokenInputView).
