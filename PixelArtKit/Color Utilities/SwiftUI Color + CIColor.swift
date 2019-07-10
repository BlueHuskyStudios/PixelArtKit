//
//  SwiftUI Color + CIColor.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import CoreImage



public extension Color {
    init?(_ ciColor: CIColor) {
        let targetColorSpace = ciColor.colorSpace
        
        if let translatedRgbColorSpace = Color.RGBColorSpace(targetColorSpace) {
            self.init(translatedRgbColorSpace, red: Double(ciColor.red), green: Double(ciColor.green), blue: Double(ciColor.blue), opacity: Double(ciColor.alpha))
        }
        else if let translatedWhiteColorSpace = Color.RGBColorSpace(monochrome: targetColorSpace),
            ciColor.numberOfComponents >= 1 {
            self.init(translatedWhiteColorSpace, white: Double(ciColor.components[0]), opacity: Double(ciColor.alpha))
        }
        else if let cgColor = ciColor.cgColor {
            self.init(cgColor)
        }
        else {
            return nil
        }
    }
}



public extension CIColor {
    
    var cgColor: CGColor? {
        return CGColor.init(colorSpace: self.colorSpace, components: self.components)
    }
}
