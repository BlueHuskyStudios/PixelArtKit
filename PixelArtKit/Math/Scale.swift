//
//  Scale.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-08.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import SwiftUI



// MARK: - ScaleProtocol

public protocol ScaleProtocol: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral
    where IntegerLiteralType == Dimension.IntegerLiteralType,
    FloatLiteralType == Dimension.FloatLiteralType
{
    associatedtype Dimension where Dimension: BinaryFloatingPoint
    
    typealias IntegerLiteralType = Dimension.IntegerLiteralType
    typealias FloatLiteralType = Dimension.FloatLiteralType
    
    
    
    init(proportional only: Dimension)
    
    
    var inverted: Self { get }
}



// MARK: ExpressibleByIntegerLiteral

extension ScaleProtocol {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(proportional: Dimension.init(integerLiteral: value))
    }
}



// MARK: ExpressibleByFloatLiteral

extension ScaleProtocol {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(proportional: Dimension.init(floatLiteral: value))
    }
}






// MARK: - Scale1D

/// A 1-dimensional scale.
///
/// Useful for scaling lines along a single axis.
///
/// - Note: If you want to scale a 2-dimensional object proportionally along both axes, you should use
///         `Scale2D.init(proportional:)`.
public struct Scale1D<Dimension>: ScaleProtocol where Dimension: BinaryFloatingPoint {
    
    public var x: Dimension
    
    
    public init(proportional only: Dimension) {
        x = only
    }
    
    
    public var inverted: Scale1D<Dimension> {
        return .init(proportional: 1.0 / x)
    }
}



public extension Scale1D {
    static var unscaled: Scale1D<Dimension> { Scale1D(proportional: 1) }
}



// MARK: - Scale2D

/// A 2-dimensional scale.
///
/// Useful for scaling any 2-dimensional object.
public struct Scale2D<Dimension>: ScaleProtocol where Dimension: BinaryFloatingPoint {
    
    public var x: Dimension
    public var y: Dimension
    
    
    public init(proportional both: Dimension) {
        x = both
        y = both
    }
    
    
    public init(x: Dimension, y: Dimension) {
        self.x = x
        self.y = y
    }
    
    
    public var inverted: Scale2D<Dimension> {
        return .init(x: 1.0 / x,
                     y: 1.0 / y)
    }
}



public extension Scale2D {
    static var unscaled: Scale2D<Dimension> { Scale2D(proportional: 1) }
    
    
    init(proportional scale1D: Scale1D<Dimension>) {
        self.init(proportional: scale1D.x)
    }
}
