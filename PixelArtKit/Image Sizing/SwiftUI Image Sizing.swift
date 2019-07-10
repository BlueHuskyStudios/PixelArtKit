//
//  SwiftUI Image Sizing.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension Image.Interpolation {
    
    /// Indicates whether this interpolation implies that anti-aliasing should occur.
    ///
    /// When there is no interpolation, then that implies that there is no anti-aliasing either (`false`).
    /// When there is any interpolation, then that implies that there is some anti-aliasing (`true`).
    var impliesAntialiasing: Bool {
        switch self {
        case .none:
            return false
            
        case .low, .medium, .high:
            return true
            
        @unknown default:
            return false
        }
    }
}



public extension View {
    
    func frame(size: CGSize, alignment: Alignment = .center) -> Self.Modified<_FrameLayout> {
        return self.frame(width: Length(size.width),
                          height: Length(size.height),
                          alignment: alignment)
    }
    
    
    func relativeSize(_ size: CGSize) -> Self.Modified<_RelativeLayoutTraitsLayout> {
        return self.relativeSize(width: size.width, height: size.height)
    }
}
