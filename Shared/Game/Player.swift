//
//  Player.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 27/11/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import GameplayKit

class Player: NSObject {
    
    static let allPlayers = [Player(stoneColor: .black), Player(stoneColor: .white)]

    var stoneColor : StoneColor
    
    init (stoneColor: StoneColor) { self.stoneColor = stoneColor }

    var opponent: Player { stoneColor == .black ? Player.allPlayers[1] : Player.allPlayers[0] }
}

extension Player: GKGameModelPlayer {
    var playerId: Int { stoneColor.rawValue }
}
