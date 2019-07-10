//
//  SwiftUI Color + UIColor.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import UIKit



public extension Color {
    init?(_ uiColor: UIColor) {
//        if uiColor.isInHsbColorSpace,
//            let hsba = uiColor.hsba {
//            self.init(hue: Double(hsba.hue),
//                      saturation: Double(hsba.saturation),
//                      brightness: Double(hsba.brightness),
//                      opacity: Double(hsba.alpha))
//        }
//        else {
//            return nil
//        }
        
        self.init(uiColor.cgColor)
    }
}



public extension UIColor {
    
    var rgba: RGBA? {
        var rgba = RGBA(red: CGFloat(), green: CGFloat(), blue: CGFloat(), alpha: CGFloat())
        let wasConverted = self.getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha)
        print(wasConverted ? "converted" : "didn't convert", self, "to", rgba)
        return wasConverted ? rgba : nil
    }
    
    
    var hsba: HSBA? {
        var hsba = HSBA(hue: CGFloat(), saturation: CGFloat(), brightness: CGFloat(), alpha: CGFloat())
        let wasConverted = self.getHue(&hsba.hue, saturation: &hsba.saturation, brightness: &hsba.brightness, alpha: &hsba.alpha)
        print(wasConverted ? "converted" : "didn't convert", self, "to", hsba)
        return wasConverted ? hsba : nil
    }
    
    
    var white: WA? {
        var wa = WA(white: CGFloat(), alpha: CGFloat())
        let wasConverted = self.getWhite(&wa.white, alpha: &wa.alpha)
        print(wasConverted ? "converted" : "didn't convert", self, "to", wa)
        return wasConverted ? wa : nil
    }
    
    
    
    /// Represents the red, green, blue, and alpha components of a color
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    /// Represents the hue, saturation, brightness, and alpha components of a color
    typealias HSBA = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    
    /// Represents the white and alpha components of a color
    typealias WA = (white: CGFloat, alpha: CGFloat)
}



//public extension UIColor {
//    
//    var isInRgbColorSpace: Bool {
//        print(self.cgColor.colorSpace)
//        return true
//    }
//}



public extension Color {
    
    static var systemRed: Color? { Color(UIColor.systemRed) }
    static var systemGreen: Color? { Color(UIColor.systemGreen) }
    static var systemBlue: Color? { Color(UIColor.systemBlue) }
    static var systemOrange: Color? { Color(UIColor.systemOrange) }
    static var systemYellow: Color? { Color(UIColor.systemYellow) }
    static var systemPink: Color? { Color(UIColor.systemPink) }
    static var systemPurple: Color? { Color(UIColor.systemPurple) }
    static var systemTeal: Color? { Color(UIColor.systemTeal) }
    static var systemIndigo: Color? { Color(UIColor.systemIndigo) }
    
    static var systemGray: Color? { Color(UIColor.systemGray2) }
    static var systemGray2: Color? { Color(UIColor.systemGray3) }
    static var systemGray3: Color? { Color(UIColor.systemGray4) }
    static var systemGray4: Color? { Color(UIColor.systemGray5) }
    static var systemGray5: Color? { Color(UIColor.systemGray6) }
    static var systemGray6: Color? { Color(UIColor.systemGray2) }
    
    static var label: Color? { Color(UIColor.label) }
    static var secondaryLabel: Color? { Color(UIColor.secondaryLabel) }
    static var tertiaryLabel: Color? { Color(UIColor.tertiaryLabel) }
    static var quaternaryLabel: Color? { Color(UIColor.quaternaryLabel) }
    
    static var link: Color? { Color(UIColor.link) }
    
    static var placeholderText: Color? { Color(UIColor.placeholderText) }
    
    static var separator: Color? { Color(UIColor.separator) }
    static var opaqueSeparator: Color? { Color(UIColor.opaqueSeparator) }
    
    static var systemBackground: Color? { Color(UIColor.systemBackground) }
    static var secondarySystemBackground: Color? { Color(UIColor.secondarySystemBackground) }
    static var tertiarySystemBackground: Color? { Color(UIColor.tertiarySystemBackground) }
    
    static var systemGroupedBackground: Color? { Color(UIColor.systemGroupedBackground) }
    static var secondarySystemGroupedBackground: Color? { Color(UIColor.secondarySystemGroupedBackground) }
    static var tertiarySystemGroupedBackground: Color? { Color(UIColor.tertiarySystemGroupedBackground) }
    
    static var systemFill: Color? { Color(UIColor.systemFill) }
    static var secondarySystemFill: Color? { Color(UIColor.secondarySystemFill) }
    static var tertiarySystemFill: Color? { Color(UIColor.tertiarySystemFill) }

    
    static var lightText: Color? { Color(UIColor.lightText) }
    static var darkText: Color? { Color(UIColor.darkText) }
}
