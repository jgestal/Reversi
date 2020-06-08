//
//  MenuBox.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 13/03/2019.
//  Copyright © 2019 Juan Gestal Romani. All rights reserved.
//

import SpriteKit


class MenuBox: SKSpriteNode {
    
    private let zPos : CGFloat = 1000
    
    let box : SKSpriteNode!
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(screenSize: CGSize, title: String) {
    
        box = SKSpriteNode(imageNamed: "MenuBox")
        
        super.init(texture: nil, color: .clear, size: screenSize)
        self.zPosition = zPos
        
        addChild(box)
        box.addChild(addTitle(title: title))
    }
    
    private func addTitle(title: String) -> SKLabelNode {
        let labelNode = SKLabelNode.init(text: title.uppercased())
        labelNode.fontName = "Helvetica-Bold"
        labelNode.fontSize = 44
        labelNode.fontColor = UIColor(red:0.85, green:0.69, blue:0.40, alpha:1.0)
        labelNode.position.y = labelNode.position.y + 200
        return labelNode
    }
}
