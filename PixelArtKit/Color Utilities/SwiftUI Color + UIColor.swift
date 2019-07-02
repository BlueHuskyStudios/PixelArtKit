//
//  SwiftUI Color + UIColor.swift
//  Pixel Art Resizer 2
//
//  Created by Ben Leggiero on 2019-07-02.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI
import UIKit



extension Color {
    init(_ uiColor: UIColor) {
        self.init(uiColor.ciColor)
    }
}
