//
//  Image Sizing.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/26/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Foundation



public extension NSImage {
    func resized(to newSize: NSSize,
                 interpolation: NSImageInterpolation = .none,
                 colorSpaceName: NSColorSpaceName = .calibratedRGB) -> NSImage {
        // Report an error if the source isn't a valid image
        guard self.isValid else {
            NSLog("Invalid Image")
            return self
        }
        
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: newSize.width.roundedToTheNearestPixel(),
            pixelsHigh: newSize.height.roundedToTheNearestPixel(),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0)
            else {
                NSLog("Failed to create bitmap representation; returning original unchanged")
                return self
        }
        rep.size = newSize
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        NSGraphicsContext.current?.imageInterpolation = interpolation
        self.draw(in: NSRect(origin: .zero, size: newSize), from: .zero, operation: .copy, fraction: 1)
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: newSize)
        newImage.addRepresentation(rep)
        return newImage
    }
    
    
    var aspectRatio: CGFloat {
        return size.aspectRatio
    }
    
    
    var sizeInPixels: NSSize {
        get {
            guard let firstRepresentation = self.representations.first else {
                NSLog("Could not find any representations")
                return size
            }
            
            return NSSize(width: firstRepresentation.pixelsWide,
                          height: firstRepresentation.pixelsHigh)
        }
//        set {
//            TODO
//        }
    }
}



public extension NSSize {
    /// Creates a size from a known width and ratio.
    ///
    /// For example, for FHD resolution, use `CGSize(width: 1920, aspectRatio: 16/9)`
    ///
    /// - Parameters:
    ///   - width:       The width of the new size
    ///   - aspectRatio: The aspect ratio of the new size; the ratio of the width to the height; the width divided by the height.
    init(width: CGFloat, aspectRatio: CGFloat) {
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
    init(height: CGFloat, aspectRatio: CGFloat) {
        self.init(width: height * aspectRatio,
                  height: height)
    }
    
    
    var aspectRatio: CGFloat {
        return width / height
    }
}



/// Something which has two dimensions, like (x, y) or (width, height)
public protocol TwoDimensional {
    
    var firstDimension: CGFloat { get }
    var secondDimension: CGFloat { get }
    
    
    
    typealias ComparisonApproach = TwoDiemnsionalComparisonApproach
}


/// How two 2D objects are compared
public enum TwoDiemnsionalComparisonApproach {
    /// Comparators register inequality if there is any difference at all
    case atAll
    
    /// Comparators register inequality based solely on the first dimension
    case first
    
    /// Comparators register inequality based solely on the second dimension
    case second
    
    /// Comparators register inequality based on the addition of both dimensions
    case additive
    
    /// Comparators register inequality based on the multiplication of both dimensions
    case multiplicative
    
    /// Comparators register inequality based on the division of both dimensions
    case divisive
}



public extension TwoDimensional {
    
    private func compare(to other: Self, approach: ComparisonApproach,
                         using comparator: (CGFloat, CGFloat) -> Bool) -> Bool {
        
        func compare(using combinator: (CGFloat, CGFloat) -> CGFloat,
                     comparator: (CGFloat, CGFloat) -> Bool) -> Bool {
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
}



extension NSSize: TwoDimensional {
    
    public var firstDimension: CGFloat {
        get {
            return width
        }
        set {
            width = newValue
        }
    }
    
    
    public var secondDimension: CGFloat {
        get {
            return height
        }
        set {
            height = newValue
        }
    }
}



extension NSPoint: TwoDimensional {
    
    public var firstDimension: CGFloat {
        get {
            return x
        }
        set {
            x = newValue
        }
    }
    
    
    public var secondDimension: CGFloat {
        get {
            return y
        }
        set {
            y = newValue
        }
    }
}
