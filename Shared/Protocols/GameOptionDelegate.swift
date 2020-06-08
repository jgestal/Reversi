//
//  GameOptionDelegate.swift
//  Reversi
//
//  Created by Juan on 08/06/2020.
//  Copyright © 2020 Juan Gestal Romani. All rights reserved.
//

import Foundation

protocol GameOptionDelegate: class {
    func selectedOption(menuBox: MenuBox, option: GameOption)
}
