//
//  Board.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 25/11/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import GameplayKit

class Board: NSObject {
    
    var currentPlayer = Player.allPlayers[0]
    
    static let size = 8
    
    static let moves = [Move(row: -1, col: -1),
                        Move(row: 0, col: -1),
                        Move(row: 1, col: -1),
                        Move(row: -1, col: 0),
                        Move(row: 1, col: 0),
                        Move(row: -1, col: 1),
                        Move(row: 0, col: 1),
                        Move(row: 1, col: 1)]
    
    var rows = [[StoneColor]]()
    
    
    // Restriction 1:
    // The movement is in the board bounds
    private func isInBounds(row: Int, col: Int) -> Bool {
        return !(row < 0 || col < 0 || row >= Board.size || col >= Board.size)
    }
    
    // Restriction 2:
    // The movement has not been made already
    private func moveHasBeenMadeAlready(row: Int, col: Int) -> Bool {
        return rows[row][col] != .empty
    }
    
    // Restriction 3:
    // The movement is legal: capture enemy stones
    private func isLegal(row: Int, col: Int) -> Bool {
        
        for move in Board.moves {
            
            var passedOpponent = false
            
            var currentRow = row
            var currentCol = col
            
            for _ in 0..<Board.size {
                
                currentRow += move.row
                currentCol += move.col
               
                // Check if new possition is in bounds
                guard isInBounds(row: currentRow, col: currentCol) else { break }
                
                let stone = rows[currentRow][currentCol]
                
                if stone == currentPlayer.opponent.stoneColor {
                    passedOpponent = true
                } else if stone == currentPlayer.stoneColor && passedOpponent {
                    return true
                } else {
                    break
                }
            }
        }
        return false
    }
    
    // Check the restrictions:
    // 1. In Bounds
    // 2. Has Been Made
    // 3. Legal
    
    func canMoveIn(row: Int, col: Int) -> Bool {
        return isInBounds(row: row, col: col) && !moveHasBeenMadeAlready(row: row, col: col) && isLegal(row: row, col: col)
    }
    
    func makeMove(currentPlayer: Player, row: Int, col: Int) -> [Move] {
        
        var didCapture = [Move]()
        
        rows[row][col] = currentPlayer.stoneColor
        
        didCapture.append(Move(row: row, col: col))

        for move in Board.moves {
            
            var mightCapture = [Move]()
            
            var currentRow = row
            var currentCol = col
            
            for _ in 0..<Board.size {
                
                currentRow += move.row
                currentCol += move.col
                
                if !isInBounds(row: currentRow, col: currentCol) { continue }
                
                let stone = rows[currentRow][currentCol]
                
                if stone == currentPlayer.opponent.stoneColor {
                    
                    mightCapture.append(Move(row: currentRow, col: currentCol))
    
                }
                
                else if stone == currentPlayer.stoneColor {
                    
                    didCapture.append(contentsOf: mightCapture)
                    
                    mightCapture.forEach {
                        rows[$0.row][$0.col] = currentPlayer.stoneColor
                    }
                    break
                    
                } else {
                    break
                }
            }
        }
        return didCapture
    }
    
    
    func getScores() -> (black: Int, white: Int) {
        
        var black = 0
        var white = 0
        
        rows.forEach {
            $0.forEach {
                black += $0 == .black ? 1 : 0
                white += $0 == .white ? 1 : 0
            }
        }
        
        return (black,white)
    }
    
    func showMoveMarks() -> [Move] {
        
        var moves = [Move]()
        
        for row in 0..<Board.size {
            for col in 0..<Board.size {
                let stone = rows[row][col]
                if stone == .blackMark || stone == .whiteMark {
                    moves.append(Move(row: row, col: col))
                }
            }
        }

        return moves
    }
    
    func getAvailableMoves() -> [Move] {
        
        var availableMoves = [Move]()
        
        for row in 0..<Board.size {
            for col in 0..<Board.size {
                if canMoveIn(row: row, col: col) {
                    availableMoves.append(Move(row: row, col: col))
                }
            }
        }
        
        return availableMoves
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
}

extension Board: GKGameModel {
    
    var players: [GKGameModelPlayer]? { return Player.allPlayers }
    var activePlayer: GKGameModelPlayer? { return currentPlayer }
    
    func setGameModel(_ gameModel: GKGameModel) {
        let board = gameModel as! Board
        currentPlayer = board.currentPlayer
        rows = board.rows
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {

        let playerObject = player as! Player
        
        let scores = getScores()
        let totalStones = scores.black + scores.white
        
        let playerStones = playerObject.stoneColor == .black ? scores.black : scores.white
        let opponentStones = playerObject.stoneColor == .black ? scores.white : scores.black
        
        // TODO: Check also if no movements for rival and IA is winning?
        return totalStones == 64 && playerStones > opponentStones
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        guard
            let player = player as? Player,
            !(isWin(for: player) || isWin(for: player.opponent))
        else { return nil }
        
        return getAvailableMoves()
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        let move = gameModelUpdate as! Move
        _ = makeMove(currentPlayer: currentPlayer, row: move.row, col: move.col)
        currentPlayer = currentPlayer.opponent
    }
}
