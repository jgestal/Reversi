//
//  Stone.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 25/11/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit



final class Stone: SKSpriteNode {
    
    private static let thinkingMark = SKTexture(imageNamed: "IAMark")
    private static let whiteMark = SKTexture(imageNamed: "WhiteMark")
    private static let blackMark = SKTexture(imageNamed: "BlackMark")
    private static let whiteTexture = SKTexture(imageNamed: "WhiteStone")
    private static let blackTexture = SKTexture(imageNamed: "BlackStone")
     
    var stoneColor : StoneColor!
    var row = 0
    var col = 0
     
    func setPlayer (_ player: StoneColor) {
        
        stoneColor = player
        
        switch player {
        
        case .white:
            texture = Stone.whiteTexture
        case .black:
            texture = Stone.blackTexture
        case .choice:
            texture = Stone.thinkingMark
        case .whiteMark:
            texture = Stone.whiteMark
        case .blackMark:
            texture = Stone.blackMark
        case .empty:
            texture = nil
        }
    }
}

extension Stone: Tappable {
    func tap() {
        guard let scene = scene as? StoneTappedDelegate else { return }
        scene.stoneTapped(self)
    }
}
