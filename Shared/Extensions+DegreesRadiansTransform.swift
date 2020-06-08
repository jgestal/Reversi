//
//  Helper.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 18/01/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
