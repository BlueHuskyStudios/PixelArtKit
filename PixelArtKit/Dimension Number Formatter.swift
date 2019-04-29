//
//  Dimension Number Formatter.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/27/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Foundation



public extension NumberFormatter {
    static let pixelDimension: NumberFormatter = {
        let pixelDimension = NumberFormatter()
        pixelDimension.allowsFloats = true
        pixelDimension.alwaysShowsDecimalSeparator = false
        return pixelDimension
    }()
}



public extension NSSize {
    
    var formattedAsPixelSize: String {
        return "\(width.formattedAsPixelSize) × \(height.formattedAsPixelSize)"
    }
}



public extension BinaryInteger {
    
    var formattedAsPixelSize: String {
        return NumberFormatter.pixelDimension.string(from: NSNumber(value: Int(self))) ?? "\(self)"
    }
}



public extension BinaryFloatingPoint {
    
    var formattedAsPixelSize: String {
        return NumberFormatter.pixelDimension.string(from: NSNumber(value: Double(self))) ?? "\(self)"
    }
}
