//
//  Hud.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 06/01/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

final class HUD: SKNode {
    
    private let whiteScoreMarker : ScoreMarker!
    private let blackScoreMarker : ScoreMarker!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(reversed: Bool, parent: SKNode, position: CGPoint) {
        
        let background = SKSpriteNode(imageNamed: "HudBackground")
                
        blackScoreMarker = ScoreMarker(type: .black, isBig: false, reversed: reversed, position: CGPoint(x: -300, y: 5))
        whiteScoreMarker = ScoreMarker(type: .white, isBig: false, reversed: reversed, position: CGPoint(x: -210, y: 5))
        
        background.addChild(whiteScoreMarker)
        background.addChild(blackScoreMarker)
        
        super.init()

        addChild(background)
        
        if (!reversed) {
            let button = GameButton(name: "HUDMenu", position: CGPoint(x: 300, y: 5)) {
                (parent as! GameScene).showGameMenu()
            }
            button.zPosition = 1
            addChild(button)
        }
        self.position = position
    }
    
    func update(whiteScore: Int, blackScore: Int, currentPlayer: Player) {
        blackScoreMarker.update(score: blackScore, enabled: currentPlayer.stoneColor == .black)
        whiteScoreMarker.update(score: whiteScore, enabled: currentPlayer.stoneColor == .white)
    }
}
