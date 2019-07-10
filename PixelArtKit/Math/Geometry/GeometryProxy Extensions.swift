//
//  GeometryProxy Extensions.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension GeometryProxy {
    
    var safeSize: CGSize {
        return self.size - self.safeAreaInsets
    }
}
