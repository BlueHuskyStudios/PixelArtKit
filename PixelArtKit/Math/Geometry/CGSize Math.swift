//
//  CGSize Math.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import CoreGraphics



public extension CGSize {
    
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs,
                      height: lhs.height * rhs)
    }
    
    
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width,
                      height: lhs.height * rhs.height)
    }
    
    
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / rhs,
                      height: lhs.height / rhs)
    }
    
    
    static func / (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width / rhs.width,
                      height: lhs.height / rhs.height)
    }
    
    
    static func + (lhs: CGSize, rhs: EdgeInsets) -> CGSize {
        return CGSize(width: lhs.width + rhs.horizontal,
                      height: lhs.height + rhs.vertical)
    }
    
    
    static func - (lhs: CGSize, rhs: EdgeInsets) -> CGSize {
        return lhs + -rhs
    }
}



/// Creates a new size with the two dimensions.
/// That is to say, `8.5 * 11` creates a tall size which is `8.5` wide and `11` high.
///
/// - Parameter lhs: The width
/// - Parameter rhs: The height
public func * (lhs: CGFloat, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs, height: rhs)
}



infix operator ×



/// Creates a new size with the two dimensions.
/// That is to say, `8.5 × 11` creates a tall size which is `8.5` wide and `11` high.
///
/// - Parameter lhs: The width
/// - Parameter rhs: The height
public func × (lhs: CGFloat, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs, height: rhs)
}
