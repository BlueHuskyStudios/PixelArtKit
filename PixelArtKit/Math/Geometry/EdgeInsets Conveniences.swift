//
//  EdgeInsets Conveniences.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension EdgeInsets {
    
    init(each: Length) {
        self.init(top: each, leading: each, bottom: each, trailing: each)
    }
    
    init(eachVertical: Length, eachHorizontal: Length) {
        self.init(top: eachVertical,
                  leading: eachHorizontal,
                  bottom: eachVertical,
                  trailing: eachHorizontal)
    }
    
    init(top: Length, eachHorizontal: Length, bottom: Length) {
        self.init(top: top,
                  leading: eachHorizontal,
                  bottom: bottom,
                  trailing: eachHorizontal)
    }
    
    var horizontal: Length {
        return leading + trailing
    }
    
    
    var vertical: Length {
        return top + bottom
    }
}



extension EdgeInsets: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Length.FloatLiteralType
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(each: Length(value))
    }
}



extension EdgeInsets: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Swift.IntegerLiteralType
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(each: Length(value))
    }
}
