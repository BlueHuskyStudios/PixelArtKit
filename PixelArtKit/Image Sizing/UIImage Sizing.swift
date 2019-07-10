//
//  Image Sizing.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/26/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import UIKit



public extension UIImage {
    
    var scalingFactor: ScalingFactor {
        return ScalingFactor(cgScale: scale)
    }
    
    
    /// Resize the image to the given size.
    ///
    /// - Parameter targetSize:           The size to resize the image to
    /// - Parameter interpolationQuality: The quality by which the resizing will be done
    /// - Parameter scalingFactor:        _optional_ The factor by which to scale the result. Defaults to the current scaling factor of this image
    /// - Returns: The resized image.
    func resize(toSize targetSize: CGSize,
                /*aspectMode: AspectMode,*/
        interpolationQuality: CGInterpolationQuality,
        scalingFactor: ScalingFactor? = nil
        ) -> UIImage?
    {
        // Inspired by https://stackoverflow.com/a/2658801/3939277
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, (scalingFactor ?? self.scalingFactor).cgScale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let cgContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        cgContext.interpolationQuality = interpolationQuality
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    var aspectRatio: CGFloat {
        return size.aspectRatio
    }
    
    
    var sizeInPixels: CGSize {
        get {
            return size * scale
        }
//        set {
//            TODO
//        }
    }
    
    
    var sizeInPoints: CGSize {
        return size
    }
    
    
    /// Calculate the image size for a given aspect mode.
    ///
    /// - Parameters:
    ///   - targetSize: The size the image should be resized to
    ///   - aspectMode: The aspect mode to calculate the actual image size
    /// - Returns: The new image size
    private func calculateAspectSize(withTargetSize targetSize: CGSize, aspectMode: AspectMode) -> CGSize? {
        switch aspectMode {
        case .fit:
            return self.calculateFitAspectSize(widthRatio: targetSize.width / self.sizeInPoints.width,
                                               heightRatio: targetSize.height / self.sizeInPoints.height)
            
        case .fill:
            return self.calculateFillAspectSize(widthRatio: targetSize.width / self.sizeInPoints.width,
                                                heightRatio: targetSize.height / self.sizeInPoints.height)
            
        case .none:
            return nil
        }
    }
    
    
    /// Calculate the size for an image to be resized in aspect fit mode; That is resizing it without
    /// cropping the image.
    ///
    /// - Parameters:
    ///   - widthRatio: The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio: The height retio of the image and the targed size the image should be resized to.
    /// - Returns: The maximum size the image can have, to fit inside the targed size, without cropping anything.
    private func calculateFitAspectSize(widthRatio: CGFloat, heightRatio: CGFloat) -> CGSize {
        if widthRatio < heightRatio {
            return CGSize(width: floor(self.sizeInPoints.width * widthRatio),
                          height: floor(self.sizeInPoints.height * widthRatio))
        }
        return CGSize(width: floor(self.sizeInPoints.width * heightRatio),
                      height: floor(self.sizeInPoints.height * heightRatio))
    }
    
    
    /// Calculate the size for an image to be resized in aspect fill mode; That is resizing it and cropping
    /// the edges of the image, if necessary.
    ///
    /// - Parameters:
    ///   - widthRatio: The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio: The height retio of the image and the targed size the image should be resized to.
    /// - Returns: The minimum size the image needs to have to fill the complete target area.
    private func calculateFillAspectSize(widthRatio: CGFloat, heightRatio: CGFloat) -> CGSize? {
        if widthRatio > heightRatio {
            return CGSize(width: floor(self.sizeInPoints.width * widthRatio),
                          height: floor(self.sizeInPoints.height * widthRatio))
        }
        return CGSize(width: floor(self.sizeInPoints.width * heightRatio),
                      height: floor(self.sizeInPoints.height * heightRatio))
    }
    
    
    
    /// Define how to crop the images to generate.
    ///
    /// - fill: Scales the content to fill the size of the view. Some portion
    ///         of the content may be clipped to fill the view’s bounds.
    /// - fit: Scales the content to fit the size of the view by maintaining
    ///        the aspect ratio. Any remaining area of the view’s bounds is transparent.
    /// - none: Default fallback - equivalent to aspect fill.
    enum AspectMode: String {
        case fill
        case fit
        case none
    }
}
