//
// NSImageExtensions.swift
// Originally from Iconizer: https://github.com/raphaelhanneken/iconizer
// Modified for use in Blue Husky Studios' PixelArtKit: https://GitHub.com/BlueHuskyStudios/PixelArtKit
//
// MIT License
//

import Cocoa

public extension NSImage {
    
    /// The size of the image, in density-independent points.
    var sizeInPoints: NSSize {
        return size
    }
    
    /// The height of the image, in density-independent points.
    var heightInPoints: CGFloat {
        return sizeInPoints.height
    }
    
    
    /// The width of the image, in density-independent points.
    var widthInPoints: CGFloat {
        return sizeInPoints.width
    }
    
    
    /// A PNG representation of the image.
    var pngRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }
        
        return nil
    }
    
    
    /// A PNG representation of the image, but without the alpha channel
    var pngRepresentationWithoutAlpha: Data? {
        guard
            let tiff = self.tiffRepresentation,
            let imgDataWithoutAlpha = NSBitmapImageRep(data: tiff)?.representation(using: .jpeg, properties: [:])
            else {
                return nil
        }
        
        return NSBitmapImageRep(data: imgDataWithoutAlpha)?.representation(using: .png, properties: [:])
    }
    
    
    /// Resize the image to the given size.
    ///
    /// - Parameter size: The size to resize the image to.
    /// - Returns: The resized image.
    func resize(toSize targetSize: NSSize, aspectMode: AspectMode) -> NSImage? {
        let newSize     = self.calculateAspectSize(withTargetSize: targetSize, aspectMode: aspectMode) ?? targetSize
        let xCoordinate = round((targetSize.width - newSize.width) / 2)
        let yCoordinate = round((targetSize.height - newSize.height) / 2)
        let targetFrame = NSRect(origin: NSPoint.zero, size: targetSize)
        let frame       = NSRect(origin: NSPoint(x: xCoordinate, y: yCoordinate), size: newSize)
        
        let backColor: NSColor
        if let tiff = self.tiffRepresentation,
            let tiffData = NSBitmapImageRep(data: tiff) {
            backColor = tiffData.colorAt(x: 0, y: 0) ?? .clear
        }
        else {
            backColor = .clear
        }
        
        return NSImage(size: targetSize, flipped: false) { _ in
            backColor.setFill()
            NSBezierPath.fill(targetFrame)
            guard let rep = self.bestRepresentation(for: NSRect(origin: NSPoint.zero, size: newSize),
                                                    context: nil,
                                                    hints: nil)
                else {
                    return false
            }
            
            return rep.draw(in: frame)
        }
    }
    
    
    /// Saves the PNG representation of the image to the supplied URL parameter.
    ///
    /// - Parameter url: The URL to save the image data to.
    /// - Throws: An NSImageExtensionError if unwrapping the image data fails.
    ///           An error in the Cocoa domain, if there is an error writing to the URL.
    func savePngTo(url: URL) throws {
        guard let png = self.pngRepresentation else {
            throw NSImageExtensionError.unwrappingPngRepresentationFailed
        }
        try png.write(to: url, options: .atomicWrite)
    }
    
    
    /// Saves the PNG representation of the image to the supplied URL parameter.
    ///
    /// - Parameter url: The URL to save the image data to.
    /// - Throws: An NSImageExtensionError if unwrapping the image data fails.
    ///           An error in the Cocoa domain, if there is an error writing to the URL.
    func savePngWithoutAlphaChannelTo(url: URL) throws {
        guard let png = self.pngRepresentationWithoutAlpha else {
            throw NSImageExtensionError.unwrappingPngRepresentationFailed
        }
        try png.write(to: url, options: .atomicWrite)
    }
    
    
    /// Calculate the image size for a given aspect mode.
    ///
    /// - Parameters:
    ///   - targetSize: The size the image should be resized to
    ///   - aspectMode: The aspect mode to calculate the actual image size
    /// - Returns: The new image size
    private func calculateAspectSize(withTargetSize targetSize: NSSize, aspectMode: AspectMode) -> NSSize? {
        if aspectMode == .fit {
            return self.calculateFitAspectSize(widthRatio: targetSize.width / self.widthInPoints,
                                               heightRatio: targetSize.height / self.heightInPoints)
        }
        
        if aspectMode == .fill {
            return self.calculateFillAspectSize(widthRatio: targetSize.width / self.widthInPoints,
                                                heightRatio: targetSize.height / self.heightInPoints)
        }
        
        return nil
    }
    
    
    /// Calculate the size for an image to be resized in aspect fit mode; That is resizing it without
    /// cropping the image.
    ///
    /// - Parameters:
    ///   - widthRatio: The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio: The height retio of the image and the targed size the image should be resized to.
    /// - Returns: The maximum size the image can have, to fit inside the targed size, without cropping anything.
    private func calculateFitAspectSize(widthRatio: CGFloat, heightRatio: CGFloat) -> NSSize {
        if widthRatio < heightRatio {
            return NSSize(width: floor(self.widthInPoints * widthRatio),
                          height: floor(self.heightInPoints * widthRatio))
        }
        return NSSize(width: floor(self.widthInPoints * heightRatio), height: floor(self.heightInPoints * heightRatio))
    }
    
    
    /// Calculate the size for an image to be resized in aspect fill mode; That is resizing it and cropping
    /// the edges of the image, if necessary.
    ///
    /// - Parameters:
    ///   - widthRatio: The width ratio of the image and the target size the image should be resized to.
    ///   - heightRatio: The height retio of the image and the targed size the image should be resized to.
    /// - Returns: The minimum size the image needs to have to fill the complete target area.
    private func calculateFillAspectSize(widthRatio: CGFloat, heightRatio: CGFloat) -> NSSize? {
        if widthRatio > heightRatio {
            return NSSize(width: floor(self.widthInPoints * widthRatio),
                          height: floor(self.heightInPoints * widthRatio))
        }
        return NSSize(width: floor(self.widthInPoints * heightRatio), height: floor(self.heightInPoints * heightRatio))
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



/// Error types for NSImageExtension
public enum NSImageExtensionError: Error {
    /// Getting the png representation for the current image failed.
    case unwrappingPngRepresentationFailed
}
