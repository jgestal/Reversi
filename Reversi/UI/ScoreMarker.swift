//
//  ScoreMarker.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 18/01/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class ScoreMarker: SKNode {
    
    private let isBig: Bool!
    private let type: ScoreMarkerType!
    private var isEnabled: Bool!
    private let background: SKSpriteNode!
    private let scoreLabel: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: ScoreMarkerType, isBig: Bool, reversed: Bool, position: CGPoint) {
        
        self.type = type
        self.isBig = isBig
        self.isEnabled = false
        
        background = SKSpriteNode()
        background.zPosition = 1
        
        scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        scoreLabel.fontColor = type == .white ? .black : .white
        scoreLabel.zPosition = 2
       
        if (isBig) {
            scoreLabel.position = CGPoint(x: 0, y: -22)
            scoreLabel.fontSize = 64
        } else {
            scoreLabel.zRotation = reversed ? 180.degreesToRadians : 0
            scoreLabel.fontSize = 32
            scoreLabel.position = CGPoint(x: 0, y: reversed ? 12 : -12)
        }
        
        super.init()

        addChild(background)
        addChild(scoreLabel)
        
        self.position = position
        
        update(score: 0, enabled: false)
    }
    
    private func backgroundImage() -> String {
        
        var backgroundImage = self.type == .white ? "ScoreMarkerWhite" : "ScoreMarkerBlack"
    
        if (isBig) {
            backgroundImage = "\(backgroundImage)Big"
        }
        
        if (isEnabled) {
            backgroundImage = "\(backgroundImage)Enabled"
        }
        
        return backgroundImage
    }

    func update(score: Int, enabled: Bool) {
        scoreLabel.text = "\(score)"
        self.isEnabled = enabled
        background.texture = SKTexture.init(imageNamed: backgroundImage())
        background.size = background.texture!.size()
    }
}
