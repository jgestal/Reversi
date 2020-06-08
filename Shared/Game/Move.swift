//
//  Move.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 27/11/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    var row: Int
    var col: Int
    
    //GKGameModelUpdate
    var value = 0

    init (row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
