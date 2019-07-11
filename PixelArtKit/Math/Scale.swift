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

public protocol ScaleProtocol {
    associatedtype Dimension where Dimension: BinaryFloatingPoint
    
    
    
    init(proportional only: Dimension)
    
    
    var inverted: Self { get }
    var allDimensions: [Dimension] { get }
    
    func isUnscaled(tolerance: Dimension) -> Bool
    func isInteger(tolerance: Dimension) -> Bool
}



// MARK: ExpressibleByIntegerLiteral

extension ScaleProtocol
    where Self: ExpressibleByIntegerLiteral,
    Dimension: ExpressibleByIntegerLiteral,
    Self.IntegerLiteralType == Dimension.IntegerLiteralType
{
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(proportional: Dimension.init(integerLiteral: value))
    }
}



// MARK: ExpressibleByFloatLiteral

extension ScaleProtocol
    where Self: ExpressibleByFloatLiteral,
    Dimension: ExpressibleByFloatLiteral,
    Self.FloatLiteralType == Dimension.FloatLiteralType
{
    public init(floatLiteral value: FloatLiteralType) {
        self.init(proportional: Dimension.init(floatLiteral: value))
    }
}



// MARK: Synthesis

public extension ScaleProtocol {
    
    func isUnscaled(tolerance: Dimension) -> Bool {
        return !allDimensions.contains { abs($0 - 1) > tolerance }
    }
    
    
    func isUnscaled() -> Bool {
        return isUnscaled(tolerance: 0.01)
    }
    
    
    func isInteger(tolerance: Dimension) -> Bool {
        return !allDimensions.contains { abs($0 - $0.rounded()) > tolerance }
    }
    
    
    func isInteger() -> Bool {
        return isInteger(tolerance: 0.01)
    }
    
    
    static var unscaled: Self { .init(proportional: 1) }
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
    
    
    public var allDimensions: [Dimension] { [x] }
}



extension Scale1D: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Dimension.IntegerLiteralType
}



extension Scale1D: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Dimension.FloatLiteralType
}



// MARK: - Scale2D

/// A 2-dimensional scale.
///
/// Useful for scaling any 2-dimensional object.
public struct Scale2D<Dimension>: ScaleProtocol where Dimension: BinaryFloatingPoint {
    
    public var x: Dimension
    public var y: Dimension
    
    
    public init(proportional both: Dimension) {
        self.init(x: both,
                  y: both)
    }
    
    
    public init(x: Dimension, y: Dimension) {
        self.x = x
        self.y = y
    }
    
    
    public var inverted: Scale2D<Dimension> {
        return .init(x: 1.0 / x,
                     y: 1.0 / y)
    }
    
    
    public var allDimensions: [Dimension] { [x, y] }
}



extension Scale2D: TwoDimensional {
    public var firstDimension: Dimension { x }
    public var secondDimension: Dimension { y }
}



public extension Scale2D {
    
    init(proportional scale1D: Scale1D<Dimension>) {
        self.init(proportional: scale1D.x)
    }
}



extension Scale2D: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Dimension.IntegerLiteralType
}



extension Scale2D: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Dimension.FloatLiteralType
}
