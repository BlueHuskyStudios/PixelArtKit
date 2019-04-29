//
//  DragDropFileView.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/27/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Cocoa



private let inactiveOpacity: Float = 0
private let readyToReceiveOpacity: Float = 1
private let cornerRadius: CGFloat = 8



/// Allows you to drop a file onto it
public class DragDropFileView: NSView {
    
    public var acceptedTypes: [DraggedItemType] = [] {
        didSet {
            self.unregisterDraggedTypes()
            self.registerForDraggedTypes(acceptedTypes.pasteboardTypes)
        }
    }
    
    private lazy var dashedBorder: CAShapeLayer = {
        
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = NSColor.controlAccentColor.cgColor
        dashedBorder.lineWidth = 2
        dashedBorder.borderWidth = 2
        dashedBorder.fillColor = NSColor.windowBackgroundColor.withAlphaComponent(0.75).cgColor
        dashedBorder.lineDashPattern = [8, 8]
        dashedBorder.frame = borderFrame
        dashedBorder.path = CGPath.init(roundedRect: borderFrame, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        dashedBorder.opacity = inactiveOpacity
        
        dashedBorder.addSublayer(labelLayer)
        
        return dashedBorder
    }()
    
    private lazy var labelLayer: CATextLayer = {
        let labelLayer = CenteredTextLayer()
        labelLayer.string = "Drop here to resize"
        labelLayer.font = NSFont.systemFont(ofSize: 24, weight: .semibold)
        labelLayer.frame = borderFrame
        labelLayer.foregroundColor = NSColor.labelColor.cgColor
        labelLayer.alignmentMode = .center
        return labelLayer
    }()
    
    private var borderFrame: NSRect { return bounds.insetBy(dx: 4, dy: 4) }
    
    public var onDrop: OnDrop?
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    
    private func commonInit() {
        self.wantsLayer = true
        self.layer?.addSublayer(dashedBorder)
        self.registerForDraggedTypes(acceptedTypes.pasteboardTypes)
    }
    
    
//    public override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//
//        let context = NSGraphicsContext.current!.cgContext
////        context.setFillColor(NSColor.red.cgColor)
////        context.fill(bounds)
//        context.setLineDash(phase: 0, lengths: [2, 2])
//        context.setStrokeColor(NSColor.green.withAlphaComponent(0.5).cgColor)
//        context.stroke(bounds)
//    }
    
    
    override public func layout() {
        super.layout()
        
        self.dashedBorder.frame = bounds
        self.dashedBorder.path = CGPath.init(roundedRect: borderFrame, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        
        self.labelLayer.frame = bounds
        self.labelLayer.contentsScale = self.window?.screen?.backingScaleFactor ?? 2
    }
    
    
    fileprivate func fade(to newOpacity: Float) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            let fade = CABasicAnimation(keyPath: "opacity")
            fade.fromValue = dashedBorder.opacity
            fade.toValue = newOpacity
            fade.duration = 0.25
            dashedBorder.add(fade, forKey: "fade")
            dashedBorder.opacity = newOpacity
        }
    }
    
    
//    public override func hitTest(_ point: NSPoint) -> NSView? {
//        // pass-through events that don't hit one of the visible subviews
//        return subviews.first { subview in
//            !subview.isHidden && nil != subview.hitTest(point)
//        }
//    }
    
    
    
    public typealias OnDrop = (_ items: [DraggedItemType.Extracted]) -> Bool
}



public extension DragDropFileView {
    enum DraggedItemType {
        case fileByExtension(extension: String)
        case fileByUti(uti: String)
        case imageByUti(uti: String)
        
        
        func extract(from pasteboard: NSPasteboard) -> Extracted? {
            if let type = pasteboard.availableType(from: pasteboardTypes) {
                switch self {
                case .fileByExtension(let `extension`):
                    guard
                        let fileUrlString = pasteboard.string(forType: type),
                        let fileUrl = URL(string: fileUrlString)
                        else {
                        return nil
                    }
                    
                    if `extension`.lowercased() == fileUrl.pathExtension.lowercased() {
                        return Extracted.fileByExtension(extension: `extension`, url: fileUrl)
                    }
                    else {
                        return nil // Extracted.fileByExtension(extension: `extension`, url: fileUrl)
                    }
                    
                case .fileByUti(let uti):
                    if let utiType = pasteboard.availableType(from: [.init(uti)]),
                        let fileUrlString = pasteboard.string(forType: utiType),
                        let fileUrl = URL(string: fileUrlString)
                    {
                        return Extracted.fileByUti(uti: uti, url: fileUrl)
                    }
                    else if let fileUrlString = pasteboard.string(forType: .init(uti)),
                        let fileUrl = URL(string: fileUrlString) {
                        return Extracted.fileByUti(uti: uti, url: fileUrl)
                    }
                    else {
                        return nil
                    }
                    
                case .imageByUti(let uti):
                    if let utiType = pasteboard.availableType(from: [.init(uti)]),
                        let imageData = pasteboard.data(forType: utiType) {
                        return Extracted.imageByUti(uti: uti, imageData: imageData)
                    }
                    else if let imageData = pasteboard.data(forType: .init(uti)) {
                        return Extracted.imageByUti(uti: uti, imageData: imageData)
                    }
                    else {
                        return nil
                    }
                }
            }
            else {
                print("No available types in pasteboard match our expected types. Expected: \(pasteboardTypes); Actual: \(pasteboard.types?.description ?? "nil")")
                return nil
            }
        }
        
        
        var pasteboardTypes: [NSPasteboard.PasteboardType] {
            switch self {
            case .fileByExtension(let `extension`):
                return Array([.fileURL, .URL, NSPasteboard.PasteboardType.fileNameType(forPathExtension: `extension`)] as Set)
                
            case .fileByUti(uti: _):
                return [.fileURL, .URL]
                
            case .imageByUti(let uti):
                return [.init(uti)]
            }
        }
        
        
        
        public enum Extracted {
            case fileByExtension(extension: String, url: URL)
            case fileByUti(uti: String, url: URL)
            case imageByUti(uti: String, imageData: Data)
        }
    }
}



public extension Array where Element == DragDropFileView.DraggedItemType {
    var pasteboardTypes: [NSPasteboard.PasteboardType] {
        return .init(Set(flatMap { $0.pasteboardTypes }))
    }
    
    
    func extractFirst(from pasteboard: NSPasteboard) -> Element.Extracted? {
        return lazy
            .compactMap { $0.extract(from: pasteboard) }
            .first
    }
    
    
    func extractAll(from pasteboard: NSPasteboard) -> [Element.Extracted] {
        return compactMap { $0.extract(from: pasteboard) }
    }
}



// MARK: - NSDraggingDestination

public extension DragDropFileView {
    
    private func draggingEnteredOrUpdated(info: NSDraggingInfo) -> NSDragOperation {
        guard nil != acceptedTypes.extractFirst(from: info.draggingPasteboard) else {
            return []
        }
        
        fade(to: readyToReceiveOpacity)
        
        return .copy
    }
    

    /// Invoked when the dragged image enters this view's bounds or frame; returns dragging operation to perform.
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return draggingEnteredOrUpdated(info: sender)
    }
    
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return draggingEnteredOrUpdated(info: sender)
    }
    
    
    /// Invoked when the dragged image exits the destination’s bounds rectangle (in the case of a view object) or its frame rectangle (in the case of a window object).
    override func draggingExited(_ sender: NSDraggingInfo?) {
        fade(to: inactiveOpacity)
    }
    
    
    /// Invoked when the image is released, allowing the receiver to agree to or refuse drag operation.
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return onDrop?(acceptedTypes.extractAll(from: sender.draggingPasteboard)) ?? false
    }
    
    
    /// Invoked after the released image has been removed from the screen, signaling the receiver to import the pasteboard data.
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    
    /// Invoked when the dragging operation is complete, signaling the receiver to perform any necessary clean-up.
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        fade(to: inactiveOpacity)
    }
    
    
    /// Called when a drag operation ends.
    override func draggingEnded(_ sender: NSDraggingInfo) {
//        Swift.print(#function)
    }
    
    
    /// Asks the destination object whether it wants to receive periodic draggingUpdated(_:) messages.
    override func wantsPeriodicDraggingUpdates() -> Bool {
        return false
    }
    
    
    /// Invoked when the dragging images should be changed.
    override func updateDraggingItemsForDrag(_ sender: NSDraggingInfo?) {
//        Swift.print(#function)
    }
}
