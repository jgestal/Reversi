//
//  Tappable.swift
//  Reversi
//
//  Created by Juan on 05/06/2020.
//  Copyright © 2020 Juan Gestal Romani. All rights reserved.
//

import SpriteKit

protocol Tappable {
    func tap()
}

extension SKScene {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           guard
               let touch = touches.first,
               let node = nodes(at: touch.location(in: self)).first as? Tappable
               else { return }
        node.tap()
    }
}
