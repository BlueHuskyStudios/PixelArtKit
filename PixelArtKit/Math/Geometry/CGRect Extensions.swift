//
//  CGRect Extensions.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 2019-07-09.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import CoreGraphics



// MARK: - Centering

public extension CGRect {
    init(centering smallerSize: CGSize, within larger: CGRect) {
        self.init(
            origin: CGPoint(x: larger.origin.x + ((larger.size.width / 2) - (smallerSize.width / 2)),
                            y: larger.origin.y + ((larger.size.height / 2) - (smallerSize.height / 2))),
            size: smallerSize
        )
    }
    
    
    init(centering smallerSize: CGSize, within largerSize: CGSize) {
        self.init(centering: smallerSize, within: CGRect(origin: .zero, size: largerSize))
    }
    
    
    init(centering smaller: CGRect, within larger: CGRect) {
        self.init(centering: smaller.size, within: larger)
    }
    
    
    init(centering smaller: CGRect, within largerSize: CGSize) {
        self.init(centering: smaller.size, within: largerSize)
    }
    
    
    func centered(within other: CGRect) -> CGRect {
        return CGRect(centering: self, within: other)
    }
    
    
    func centered(within otherSize: CGSize) -> CGRect {
        return CGRect(centering: self, within: otherSize)
    }
}



public extension CGSize {
    
    func centered(within parent: CGRect) -> CGRect {
        return CGRect(centering: self, within: parent)
    }
    
    
    func centered(within other: CGSize) -> CGRect {
        return CGRect(centering: self, within: other)
    }
}
