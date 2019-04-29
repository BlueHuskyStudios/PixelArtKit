//
//  CenteredTextLayer.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/28/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Foundation



/// A CoreAnimation text layer which vertically centers its text
///
/// From https://stackoverflow.com/a/32462462/3939277
class CenteredTextLayer : CATextLayer {
    
    // REF: http://lists.apple.com/archives/quartz-dev/2008/Aug/msg00016.html
    // CREDIT: David Hoerl - https://github.com/dhoerl
    // USAGE: To fix the vertical alignment issue that currently exists within the CATextLayer class. Change made to the yDiff calculation.
    
    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        
        context.saveGState()
        context.translateBy(x: 0, y: -yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
