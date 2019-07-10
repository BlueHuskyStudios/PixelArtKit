//
//  ScalingFactor.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public enum ScalingFactor {
    /// Use the scaling factor of the device's main screen
    case device
    
    /// A 1-to-1 scaling factor. Default for traditional screens
    case perPixel
    
    /// The high-DPI 200% scaling factor. Retina Macs and some iPhones use this
    case retina2x
    
    /// The high-DPI 300% scaling factor. Most iPhones use this
    case retina3x
    
    /// A custom scaling factor. Use this for uncommon screens and other custom uses
    case exact(multiplier: Length)
    
    
    /// The scale passed to CoreGraphics
    public var cgScale: Length {
        switch self {
        case .device: return 0
        case .perPixel: return 1
        case .retina2x: return 2
        case .retina3x: return 3
        case .exact(let multiplier): return multiplier
        }
    }
    
    
    /// Creates a scaling factor based on the given CoreGraphics-formatted scale.
    ///
    /// - Attention: This generally works as expected (`1` gives `.perPixel`; `2` gives `.retina2x`, etc.), except that
    ///              `0` is interpreted as the special value `.device`.
    ///
    /// - Parameters:
    ///   - cgScale:   The CoreGraphics scale of this factor
    ///   - tolerance: _optional_ - The distance away from each tier that `cgScale` can be while still being
    ///                 interpreted as that tier. For instance `ScalingFactor(cgScale: 1.01, tolerance: 1.1)` gives
    ///                 `.perPixel`, but `ScalingFactor(cgScale: 1.01, tolerance: 0.001)` gives
    ///                 `.exact(multiplier: 1.01)`.
    ///                 Defaults to `0.01`.
    public init(cgScale: Length, tolerance: Length = 0.01) {
        let tolerance = abs(tolerance)
        
        if cgScale.distance(to: 0) < tolerance {
            self = .device
        }
        else if cgScale.distance(to: 1) < tolerance {
            self = .perPixel
        }
        else if cgScale.distance(to: 2) < tolerance {
            self = .retina2x
        }
        else if cgScale.distance(to: 3) < tolerance {
            self = .retina3x
        }
        else {
            self = .exact(multiplier: cgScale)
        }
    }
}



@available(macOS 10.15, *)
@available(iOS 13, *)
extension ScalingFactor {
    /// Finds the appropriate multiplier for this scaling factor. This is distinct from `.cgScale` because it will
    /// return the actual device screen multiplier for `.device`, whereas `.cgScale` would return `0`.
    ///
    /// - Parameter main: _optional_ - The screen to use if this scaling factor is `.device`. Defaults to `.main`.
    public func multiplier(on screen: UIKit.UIScreen = .main) -> Length {
        switch self {
        case .device: return screen.scale
        case .perPixel: return 1
        case .retina2x: return 2
        case .retina3x: return 3
        case .exact(let multiplier): return multiplier
        }
    }
}
