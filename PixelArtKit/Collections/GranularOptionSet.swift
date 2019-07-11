//
//  GranularOptionSet.swift
//  PixelArtKit
//
//  Created by Ben Leggiero @ RRD on 7/10/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// An OptionSet which is made up of individual "granules".
///
/// This is useful when sometimes a set of options is inclusive (like when passing a combined set of options; an `OptionSet`), and sometimes it is exclusive
/// (like when iterating over those options; a `Granule`, usually some `enum`).
public protocol GranularOptionSet: OptionSet {
    associatedtype Granule: GranuleProtocol where Granule.RawValue == Self.RawValue
}



public protocol GranularOptionSetGranule: RawRepresentable, CaseIterable where RawValue: BinaryInteger {
    /// Indicates whether this granule is a bit mask for its option set. That is to say, whether one granule with a raw
    /// value of `3` would correspond to an option set with a single element with a raw value of `1 << 3`.
    ///
    /// This defaults to `true`.
    static var indicatesBitMask: Bool { get }
}



public extension GranularOptionSet {
    typealias GranuleProtocol = GranularOptionSetGranule
}



// MARK: - Synthesis

public extension GranularOptionSet {
    init(exactly granule: Granule) {
        self.init(rawValue: granule.rawValue)
    }
    
    
    init(shifting granule: Granule) {
        self.init(rawValue: 1 << granule.rawValue)
    }
    
    
    init(_ granule: Granule) {
        if Granule.indicatesBitMask {
            self.init(shifting: granule)
        }
        else {
            self.init(exactly: granule)
        }
    }
}



public extension GranularOptionSet where Element == Self {
    
    var granules: [Granule] {
        return Granule.allCases.filter(contains)
    }
    
    
    func contains(granule: Granule) -> Bool {
        return self.contains(Self.init(rawValue: granule.autoShiftedRawValue))
    }
}



public extension GranularOptionSetGranule {
    
    static var indicatesBitMask: Bool { true }
    
    
    var autoShiftedRawValue: RawValue {
        if Self.indicatesBitMask {
            return 1 << self.rawValue
        }
        else {
            return self.rawValue
        }
    }
}
