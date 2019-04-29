//
//  Filetype Conveniences.swift
//  PixelArtKit
//
//  Created by Ben Leggiero on 4/28/19.
//  Copyright © 2019 Blue Husky Studios BH-1-PS
//

import Foundation



public extension URL {
    
    func ensuringPathExtension(_ requiredPathExtension: String) -> URL {
        if self.pathExtension == requiredPathExtension {
            return self
        }
        else {
            return self.deletingPathExtension().appendingPathExtension(requiredPathExtension)
        }
    }
    
    
    mutating func ensurePathExtension(_ requiredPathExtension: String) {
        self = ensuringPathExtension(requiredPathExtension)
    }
}



public extension NSString {
    
    func ensuringPathExtension(_ requiredPathExtension: String) -> NSString {
        if self.pathExtension == requiredPathExtension {
            return self
        }
        else {
            let withoutPathExtension = self.deletingPathExtension as NSString
            return (withoutPathExtension.appendingPathExtension(requiredPathExtension) as NSString?) ?? withoutPathExtension
        }
    }
}



public extension NSMutableString {
    
    func ensurePathExtension(_ requiredPathExtension: String) {
        self.deleteCharacters(in: NSRange(location: 0, length: length))
        self.append(ensuringPathExtension(requiredPathExtension) as String)
    }
}



public extension String {
    
    func ensuringPathExtension(_ requiredPathExtension: String) -> String {
        if (self as NSString).pathExtension == requiredPathExtension {
            return self
        }
        else {
            let withoutPathExtension = (self as NSString).deletingPathExtension as NSString
            return withoutPathExtension.appendingPathExtension(requiredPathExtension) ?? (withoutPathExtension as String)
        }
    }
    
    
    mutating func ensurePathExtension(_ requiredPathExtension: String) {
        self = ensuringPathExtension(requiredPathExtension)
    }
}
