//
//  HasAlso.swift
//  PixelArtKit
//
//  Created by Ben Leggiero @ RRD on 7/10/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public protocol HasAlso {
    func also(_ accessoryOperation: () -> Void) -> Self
    func also(_ accessoryOperation: (Self) -> Void) -> Self
}



public extension HasAlso {
    func also(_ accessoryOperation: () -> Void) -> Self {
        accessoryOperation()
        return self
    }
    
    
    func also(_ accessoryOperation: (Self) -> Void) -> Self {
        accessoryOperation(self)
        return self
    }
}



// MARK: - Default Synthesis

extension Int8: HasAlso {}
extension Int16: HasAlso {}
extension Int32: HasAlso {}
extension Int64: HasAlso {}
extension Int: HasAlso {}

extension Float: HasAlso {}
extension Double: HasAlso {}

extension String: HasAlso {}
