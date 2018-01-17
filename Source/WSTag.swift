//
//  WSTag.swift
//  Whitesmith
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import Foundation

public struct WSTag: Hashable {

    public let id: String
    
    public let text: String
    
    public var isSelectedToBeRemoved: Bool

    public init(_ text: String) {
        self.id = UUID().uuidString.lowercased()
        self.text = text
        self.isSelectedToBeRemoved = false
    }

    public var hashValue: Int {
        return self.id.hashValue
    }

    public func equals(_ other: WSTag) -> Bool {
        return (self.id == other.id) && (self.text == other.text)
    }

}

public func == (lhs: WSTag, rhs: WSTag) -> Bool {
    return lhs.equals(rhs)
}
