//
//  MenuScene.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 19/01/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    
    let buttonNames = ["Easy", "Normal", "Hard", "TwoPlayers"]
    
    private lazy var logo : SKSpriteNode = {
        let logo = SKSpriteNode(texture: SKTexture.init(imageNamed: "Logo"))
        logo.position = CGPoint(x: 0, y: 274)
        return logo
    }()
    
    private lazy var background : SKSpriteNode = {
        let texture = SKSpriteNode(texture: SKTexture.init(imageNamed: "BrownBackground"))
        texture.size = size
        return texture
    }()

    override func didMove(to view: SKView) {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        addChild(background)
        addChild(logo)
        
        addButtons()
    }
    
    private func addButtons() {
        
        let sep = 96  * -1.5
        
        addChild(GameButton(name: "Easy", position: CGPoint(x: 0, y: 0)) {
            self.createGameScene(gameMode: .vsEasyAI)
        })
        addChild(GameButton(name: "Normal", position: CGPoint(x: 0, y:sep)) {
            self.createGameScene(gameMode: .vsNormalAI)
        })
        addChild(GameButton(name: "Hard", position: CGPoint(x: 0, y: sep*2)) {
            self.createGameScene(gameMode: .vsHardAI)
        })
        addChild(GameButton(name: "TwoPlayers", position: CGPoint(x: 0, y: sep*3)) {
            self.createGameScene(gameMode: .vsHuman)
        })
    }
 
    private func createGameScene(gameMode: GameMode) {
        let scene = GameScene(size: size)
        scene.gameMode = gameMode
        self.view?.presentScene(scene)
    }
}
