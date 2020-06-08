//
//  FXSound.swift
//  Reversi
//
//  Created by Juan on 05/06/2020.
//  Copyright © 2020 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

final class SFXSound {
    
    private(set) static var badMove: SKAction!
    private(set) static var stone: SKAction!
    private(set) static var flip: SKAction!
    
    static func load() {
        badMove = SKAction.playSoundFileNamed("bad_move", waitForCompletion: false)
        flip = SKAction.playSoundFileNamed("flip", waitForCompletion: false)
    }
}
