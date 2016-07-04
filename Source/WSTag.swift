//
//  Tag.swift
//  Pearland
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Pearland. All rights reserved.
//

import Foundation

public struct Tag: Hashable {

    public let displayText: String

    public init(displayText: String) {
        self.displayText = displayText
    }

    public var hashValue: Int {
        return self.displayText.hashValue
    }

    public func equals(other: Tag) -> Bool {
        return self.displayText == other.displayText
    }

}

public func ==(lhs: Tag, rhs: Tag) -> Bool {
    return lhs.equals(rhs)
}
