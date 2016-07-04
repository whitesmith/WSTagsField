# WSTagsField

<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="https://github.com/cocoapods/cocoapods"><img src="https://img.shields.io/cocoapods/v/WSTagsField.svg"></a>
[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://opensource.org/licenses/MIT)

An iOS text field that represents different Tags.

![WSTagsField](http://i.imgur.com/9di8WTz.png)

## Usage

``` swift

let tagsField = WSTagsField()
tagsField.backgroundColor = .whiteColor()
tagsField.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
tagsField.spaceBetweenTags = 10.0
tagsField.font = UIFont.systemFontOfSize(12.0)
tagsField.tintColor = .greenColor()
tagsField.textColor = .blackColor()
tagsField.fieldTextColor = .blueColor()
tagsField.selectedColor = .blackColor()
tagsField.selectedTextColor = .redColor()
tagsField.delimiter = ","

// Events
tagsField.onDidAddTag = { _ in
    print("DidAddTag")
}

tagsField.onDidRemoveTag = { _ in
    print("DidRemoveTag")
}

tagsField.onDidChangeText = { _, text in
    print("DidChangeText")
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

#### <img src="https://dl.dropboxusercontent.com/u/11377305/resources/cocoapods.png" width="24" height="24"> [CocoaPods]

[CocoaPods]: http://cocoapods.org

To install it, simply add the following line to your **Podfile**:

```ruby
pod "WSTagsField"
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 1.0 or newer.

#### Manually

Download all the source files and drop them into your project.

## Requirements

* iOS 8.0+
* Xcode 7 (Swift 2.2)

# Contributing

The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/whitesmith/WSTagsField/issues/new) if you find bugs or have questions. :octocat:

# Credits
![Whitesmith](http://i.imgur.com/Si2l3kd.png)

This project was heavily inspired by [CLTokenInputView](https://github.com/clusterinc/CLTokenInputView).
