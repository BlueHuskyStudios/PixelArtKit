//
//  CGFloat from more things.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/26/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Cocoa



public extension NSTextField {
    var cgFloatValue: CGFloat {
        get {
            return .init(doubleValue)
        }
        set {
            doubleValue = newValue.native
        }
    }
}
