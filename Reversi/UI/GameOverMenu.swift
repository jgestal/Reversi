//
//  GameOverMenuBox.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 31/03/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class GameOverMenu: MenuBox {
    
    private let whiteScoreMarker : ScoreMarker!
    private let blackScoreMarker : ScoreMarker!
          
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private weak var delegate : GameOptionDelegate!

    init(screenSize: CGSize, delegate: GameOptionDelegate, blackScore: Int, whiteScore: Int) {
        
        whiteScoreMarker = ScoreMarker.init(type: .white, isBig: true, reversed: false, position: CGPoint(x: 100, y: 40))
        blackScoreMarker = ScoreMarker.init(type: .black, isBig: true, reversed: false, position: CGPoint(x: -100, y: 40))
            
        super.init(screenSize: screenSize, title: "Game Over")
        
        self.delegate = delegate
        
        let groupRectangle = SKSpriteNode(imageNamed: "ScoreRectangle")
        groupRectangle.position = CGPoint(x: 0, y: 34)
        groupRectangle.addChild(blackScoreMarker)
        groupRectangle.addChild(whiteScoreMarker)
        box.addChild(groupRectangle)
        
        blackScoreMarker.update(score: blackScore, enabled: blackScore > whiteScore)
        whiteScoreMarker.update(score: whiteScore, enabled: whiteScore > blackScore)
        
        box.addChild(winnerLabel(text: winnerText(whiteScore: whiteScore, blackScore: blackScore)))
        
        box.addChild(GameButton(name: "RoundedMenu", position: CGPoint(x: 164, y: -180), action: {
            delegate.selectedOption(menuBox: self, option: .returnToMainMenu)
        }))
        box.addChild(GameButton(name: "PlayAgain", position: CGPoint(x: -64, y: -180), action: {
            delegate.selectedOption(menuBox: self, option: .restartGame)
        }))
    }
    
    private func winnerLabel(text: String) -> SKLabelNode {
        
        let winnerLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        winnerLabel.fontSize = 48
        winnerLabel.text = text
        winnerLabel.position = CGPoint(x: 0, y: -58)
        
        return winnerLabel
    }
    
    private func winnerText(whiteScore: Int, blackScore: Int) -> String {
        
        if (blackScore > whiteScore) { return "BLACK WINS" }
        if (whiteScore > blackScore) { return "WHITE WINS" }
        return "DRAW GAME"
    }
 
}

