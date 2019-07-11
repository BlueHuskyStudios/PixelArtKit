//
//  Resize Utilities.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import SwiftUI



/// Something which has two dimensions, like (x, y) or (width, height)
public protocol TwoDimensional {
    
    associatedtype Dimension
    
    var firstDimension: Dimension { get }
    var secondDimension: Dimension { get }
}


/// How two 2D objects are compared
public enum TwoDiemnsionalComparisonApproach {
    /// Comparators register inequality if there is any difference at all
    case atAll
    
    /// Comparators register inequality based solely on the first dimension
    case first
    
    /// Comparators register inequality based solely on the second dimension
    case second
    
    /// Comparators register inequality based on the sum of both dimensions
    case additive
    
    /// Comparators register inequality based on the product of both dimensions
    case multiplicative
    
    /// Comparators register inequality based on the quotient of both dimensions
    case divisive
}



public extension TwoDimensional where Dimension: FloatingPoint {
    
    private func compare(to other: Self, approach: ComparisonApproach,
                         using comparator: (Dimension, Dimension) -> Bool) -> Bool {
        
        func compare(using combinator: (Dimension, Dimension) -> Dimension,
                     comparator: (Dimension, Dimension) -> Bool) -> Bool {
            return comparator(
                combinator(self.firstDimension, self.secondDimension),
                combinator(other.firstDimension, other.secondDimension)
            )
        }
        
        
        switch approach {
        case .atAll:
            return comparator(self.firstDimension, other.firstDimension)
                || comparator(self.secondDimension, other.secondDimension)
            
        case .first:
            return comparator(self.firstDimension, other.firstDimension)
            
        case .second:
            return comparator(self.secondDimension, other.secondDimension)
            
        case .additive:
            return compare(using: +, comparator: comparator)
            
        case .multiplicative:
            return compare(using: *, comparator: comparator)
            
        case .divisive:
            return compare(using: /, comparator: comparator)
        }
    }
    
    
    func isLessThan(_ other: Self, approach: ComparisonApproach) -> Bool {
        return compare(to: other, approach: approach, using: <)
    }
    
    
    func isGreaterThan(_ other: Self, approach: ComparisonApproach) -> Bool {
        return compare(to: other, approach: approach, using: >)
    }
    
    
    var smallestDimension: Dimension {
        return min(firstDimension, secondDimension)
    }
    
    
    var largestDimension: Dimension {
        return max(firstDimension, secondDimension)
    }
    
    
    
    typealias ComparisonApproach = TwoDiemnsionalComparisonApproach
}



public typealias Margin = EdgeInsets



public enum ViewOrientation {
    case square
    case portrait
    case landscape
}



// MARK: - Exclusive to Apple Platforms

@available(macOS 10.15, *)
@available(iOS 13, *)
public extension CoreGraphics.CGSize {
    /// Creates a size from a known width and ratio.
    ///
    /// For example, for FHD resolution, use `CGSize(width: 1920, aspectRatio: 16/9)`
    ///
    /// - Parameters:
    ///   - width:       The width of the new size
    ///   - aspectRatio: The aspect ratio of the new size; the ratio of the width to the height; the width divided by the height.
    init(width: Length, aspectRatio: Length) {
        self.init(width: width,
                  height: width / aspectRatio)
    }
    
    
    /// Creates a size from a known height and ratio.
    ///
    /// For example, for FHD resolution, use `CGSize(height: 1080, aspectRatio: 16/9)`
    ///
    /// - Parameters:
    ///   - height:      The height of the new size
    ///   - aspectRatio: The aspect ratio of the new size; the ratio of the width to the height; the width divided by the height.
    init(height: Length, aspectRatio: Length) {
        self.init(width: height * aspectRatio,
                  height: height)
    }
    
    
    var aspectRatio: Length {
        return width / height
    }
    
    
    var orientation: ViewOrientation {
        if aspectRatio.distance(to: 1) < 0.01 {
            return .square
        }
        else if aspectRatio < 1 {
            return .portrait
        }
        else {
            return .landscape
        }
    }
    
    
    func fitted(within other: CGSize, margin: Margin) -> CGSize {
        return fitted(within: other - margin)
    }
    
    
    func fitted(within other: CGSize) -> CGSize {
        return resized(within: other, mode: .fit)
    }
    
    
    /// Calculate the image size for a given aspect mode.
    ///
    /// - Parameters:
    ///   - other: The size the image should be resized to
    ///   - mode:  The mode by which to calculate the actual image size
    ///
    /// - Returns: The new image size
    func resized(within other: CGSize, mode: ContentMode) -> CGSize {
        return resized(widthRatio: other.width / self.width,
                       heightRatio: other.height / self.height,
                       mode: mode)
    }
    
    
    /// Calculate the image size for a given aspect mode.
    ///
    /// - Parameters:
    ///   - widthRatio:  The ratio of the other size's width to this size's width
    ///   - heightRatio: The ratio of the other size's height to this size's height
    ///   - mode:        The mode by which to calculate the actual image size
    ///
    /// - Returns: The new image size
    private func resized(widthRatio: Length, heightRatio: Length, mode: ContentMode) -> CGSize {
        switch mode {
        case .fit:
            return self.calculateFitAspectSize(widthRatio: widthRatio, heightRatio: heightRatio)
            
        case .fill:
            return self.calculateFillAspectSize(widthRatio: widthRatio, heightRatio: heightRatio)
        }
    }
    
    
    /// Calculate the size for an image to be resized in fit mode; That is resizing it without
    /// cropping the image.
    ///
    /// - Parameters:
    ///   - widthRatio: The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio: The height retio of the image and the targed size the image should be resized to.
    ///
    /// - Returns: The maximum size the image can have, to fit inside the targed size, without cropping anything.
    private func calculateFitAspectSize(widthRatio: Length, heightRatio: Length) -> CGSize {
        return calculateAspectSize(widthRatio: widthRatio, heightRatio: heightRatio, shouldUseWidthRatio: <)
    }
    
    
    /// Calculate the size for an image to be resized in fill mode; That is resizing it and cropping
    /// the edges of the image, if necessary.
    ///
    /// - Parameters:
    ///   - widthRatio: The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio: The height retio of the image and the targed size the image should be resized to.
    ///
    /// - Returns: The minimum size the image needs to have to fill the complete target area.
    private func calculateFillAspectSize(widthRatio: Length, heightRatio: Length) -> CGSize {
        return calculateAspectSize(widthRatio: widthRatio, heightRatio: heightRatio, shouldUseWidthRatio: >)
    }
    
    
    /// Calculate the size for an image to be resized in any mode; That is resizing it and cropping
    /// the edges of the image, if necessary.
    ///
    /// - Parameters:
    ///   - widthRatio:          The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio:         The height retio of the image and the targed size the image should be resized to.
    ///   - shouldUseWidthRatio: Returns: `true` iff the `widthRatio` should be the multiplier which is used to
    ///                          determine the new size. `false` iff `heightRatio` should be used instead.
    ///    - widthRatio: `widthRatio` exactly
    ///    - heightRatio: `heightRatio` exactly
    ///
    /// - Returns: The minimum size the image needs to have to fill the complete target area.
    private func calculateAspectSize(widthRatio: Length,
                                     heightRatio: Length,
                                     shouldUseWidthRatio: (_ widthRatio: Length, _ heightRatio: Length) -> Bool
        ) -> CGSize
    {
        if shouldUseWidthRatio(widthRatio, heightRatio) {
            return CGSize(width: floor(self.width * widthRatio),
                          height: floor(self.height * widthRatio))
        }
        return CGSize(width: floor(self.width * heightRatio),
                      height: floor(self.height * heightRatio))
    }
}



@available(macOS 10.15, *)
@available(iOS 13, *)
extension CoreGraphics.CGSize: TwoDimensional {
    
    public var firstDimension: Length {
        get {
            return width
        }
        set {
            width = newValue
        }
    }
    
    
    public var secondDimension: Length {
        get {
            return height
        }
        set {
            height = newValue
        }
    }
}



@available(macOS 10.15, *)
@available(iOS 13, *)
extension CGPoint: TwoDimensional {
    
    public var firstDimension: Length {
        get {
            return x
        }
        set {
            x = newValue
        }
    }
    
    
    public var secondDimension: Length {
        get {
            return y
        }
        set {
            y = newValue
        }
    }
}
