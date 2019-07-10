//
//  Rounding.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/27/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Foundation



public extension BinaryFloatingPoint {
    func roundedToTheNearestPixel<IntType: BinaryInteger>() -> IntType {
        return IntType.init(rounded())
    }
}
