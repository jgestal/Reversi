//
//  GameOverMenuBox.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 31/03/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class GameOverMenu: MenuBox {
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private weak var delegate : GameOption
    
    init(screenSize: CGSize, delegate: GameOption) {
        
        super.init(screenSize: screenSize, title: "Game Over")
        
        self.delegate = delegate
        //box.addChild(scores())
    
        box.addChild(winnerLabel(text: "White wins")) // DRAW
        
        
        box.addChild(GameButton(name: "RoundedMenu", position: CGPoint(x: 164, y: -180), action: {
            
        }))
        box.addChild(GameButton(name: "PlayAgain", position: CGPoint(x: -64, y: -180), action: {
                 
        }))
        
    }
    
    private func winnerLabel(text: String) -> SKLabelNode {
        
        let winnerLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        winnerLabel.fontSize = 48
        winnerLabel.text = text
        winnerLabel.position = CGPoint(x: 0, y: -58)
        
        return winnerLabel
    }
    
    private func scores() -> SKSpriteNode {
        
        let scoreRectangle = SKSpriteNode(imageNamed: "ScoreRectangle")
        
        scoreRectangle.position = CGPoint(x: 0, y: 34)
        scoreRectangle.addChild(ScoreMarker.init(type: .white, isBig: true, reversed: false, parent: scoreRectangle, position: CGPoint(x: 100, y: 40)))
        scoreRectangle.addChild(ScoreMarker.init(type: .black, isBig: true, reversed: false, parent: scoreRectangle, position: CGPoint(x: -100, y: 40)))
        
        return scoreRectangle
    }
}

