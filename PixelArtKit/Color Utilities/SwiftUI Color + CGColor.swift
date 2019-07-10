//
//  SwiftUI Color + CGColor.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import CoreGraphics



public extension Color {
    init?(_ cgColor: CGColor) {
        guard
            let cgColorSpace = cgColor.colorSpace,
            let colorSpaceKind = cgColorSpace.kind,
            let components = cgColor.components
            else {
            return nil
        }
        
        switch colorSpaceKind {
        case .rgb(kind: let rgbKind):
            let red =   Double(components[0])
            let green = Double(components[1])
            let blue =  Double(components[2])
            let alpha = Double(components.count >= 4 ? components[3] : 1)
            self.init(RGBColorSpace(rgbKind), red: red, green: green, blue: blue, opacity: alpha)
            
        case .greyscale(linear: _):
            let greyScale = Double(components[0])
            let alpha =     Double(components.count >= 2 ? components[1] : 1)
            self.init(white: greyScale, opacity: alpha)
            
        case .cmyk,
             .lab:
            return nil
        }
    }
}



public extension Color.RGBColorSpace {
    
    /// Iff the given CoreGraphics color space can be directly, unambiguously translated to a SwiftUI RGB color space,
    /// then this initializes this RGB color space as that analogous one. Otherwise, this returns `nil`.
    ///
    /// Note that, even though SwiftUI uses a RGB color space for non-RGB colors (e.g. gray, white, CMYK, etc.), this
    /// will return `nil` for those color spaces since there is no direct, unambiguous analog.
    /// For gray and white color space translation, see `init(monchrome:)`
    init?(_ cgColorSpace: CGColorSpace) {
        switch cgColorSpace.name {
        case CGColorSpace.displayP3:
            self = .displayP3
            
        case CGColorSpace.sRGB,
             CGColorSpace.extendedSRGB:
            self = .sRGB
            
        case CGColorSpace.linearSRGB,
             CGColorSpace.extendedLinearSRGB:
            self = .sRGBLinear
            
        default:
            return nil
        }
    }
    
    
    init(_ rgbKind: ColorSpaceKind.Rgb) {
        switch rgbKind {
        case .srgb(linear: false),
             .adobe,
             .other(linear: false):
            self = .sRGB
            
        case .srgb(linear: true),
             .other(linear: true):
            self = .sRGBLinear
            
        case .p3(linear: _):
            self = .displayP3
        }
    }
}



public extension CGColorSpace {
    
    /// - Returns: A distillation of this color space as a broad kind of color space
    var kind: ColorSpaceKind? {
        switch name {
        case CGColorSpace.displayP3,
             CGColorSpace.displayP3_HLG,
             CGColorSpace.displayP3_PQ_EOTF,
             CGColorSpace.dcip3:
            return .rgb(kind: .p3(linear: false))
            
        case CGColorSpace.extendedLinearDisplayP3:
            return .rgb(kind: .p3(linear: true))
            
        case CGColorSpace.sRGB,
             CGColorSpace.extendedSRGB:
            return .rgb(kind: .srgb(linear: false))
            
        case CGColorSpace.linearSRGB,
             CGColorSpace.extendedLinearSRGB:
            return .rgb(kind: .srgb(linear: true))
            
        case CGColorSpace.extendedGray,
             CGColorSpace.genericGrayGamma2_2:
            return .greyscale(linear: false)
            
        case CGColorSpace.linearGray,
             CGColorSpace.extendedLinearGray:
            return .greyscale(linear: true)
            
        case CGColorSpace.adobeRGB1998:
            return .rgb(kind: .adobe)
            
        case CGColorSpace.genericCMYK:
            return .cmyk
            
        case CGColorSpace.genericRGBLinear:
            return .rgb(kind: .other(linear: true))
            
        case CGColorSpace.rommrgb:
            return .rgb(kind: .other(linear: false))
            
        case CGColorSpace.genericLab:
            return .lab
            
        default:
            return nil
        }
    }
}



public enum ColorSpaceKind {
    case greyscale(linear: Bool)
    case rgb(kind: Rgb)
    case cmyk
    case lab
    
    
    public enum Rgb {
        case srgb(linear: Bool)
        case adobe
        case p3(linear: Bool)
        case other(linear: Bool)
    }
}
