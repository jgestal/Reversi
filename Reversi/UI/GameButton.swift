//
//  GameButton.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 31/03/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

final class GameButton: SKSpriteNode {
    
    private var normalStateTexture : SKTexture!
    
    private var action : () -> ()
    
    private lazy var selectedStateTexture : SKTexture = {
        return SKTexture.init(imageNamed: "\(name!)ButtonPressed")
    }()
    
    private var state : GameButtonState = .normal {
        didSet {
            texture = state == .normal ? normalStateTexture : selectedStateTexture
        }
    }
    
    init(name: String, position: CGPoint, action: @escaping () -> ()) {
        
        let texture = SKTexture(imageNamed: "\(name)Button")

        self.action = action
        super.init(texture: texture, color: .clear, size: texture.size())

        self.name = name
        self.position = position

        normalStateTexture = texture;
        state = .normal
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameButton: Tappable {
    internal func tap() {
        state = .selected
        run(SKAction.sequence(
            [SKAction.wait(forDuration: 0.2),
             SKAction.run { self.state = .normal },
             SKAction.wait(forDuration: 0.1),
             SKAction.run { self.action() }
            ]))
    }
}
