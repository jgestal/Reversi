//
//  GameOptionsMenuBox.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 13/03/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

class GameOptionMenu: MenuBox {
    
    private weak var delegate : GameOptionDelegate!
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(screenSize: CGSize, delegate: GameOptionDelegate) {
        
        self.delegate = delegate
        super.init(screenSize: screenSize, title: "Game Options")
        
        let yOffset = 80
        let sep = 80  * -1.5

        box.addChild(GameButton(name: "Continue", position: CGPoint(x: 0, y: yOffset)) {
            delegate.selectedOption(menuBox: self, option: .continueGame)
        })
        box.addChild(GameButton(name: "Restart", position: CGPoint(x: 0, y: Int(sep) + yOffset)) {
            delegate.selectedOption(menuBox: self, option: .restartGame)
        })
        box.addChild(GameButton(name: "MainMenu", position: CGPoint(x: 0, y: Int(sep) * 2 + yOffset)) {
            delegate.selectedOption(menuBox: self, option: .returnToMainMenu)
        })
        
    }
}
