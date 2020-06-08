//
//  GameScene.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 25/11/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {

    private var gameBoard : SKSpriteNode!
    private var topHUD : HUD!
    private var bottomHUD : HUD!
    private var board: Board!
    private var rows = [[Stone]]()
    private var strategist: GKMonteCarloStrategist!
                  
    var gameMode : GameMode!

    override func didMove(to view: SKView) {
        
        SFXSound.load()
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black

        setupGameBoard()
        setupHuds()
        setupStones()
        
        if gameMode != .vsHuman {
            setupStrategist()
        }

        showPossibleMoves()
        
        updateHuds()
    }
    
    private func setupGameBoard() {
        
        gameBoard = SKSpriteNode(imageNamed: "Board")
        gameBoard.name = "board"
        gameBoard.zPosition = 2
        
        addChild(gameBoard)
    }

    private func setupHuds() {
        
        let topHUDYPos = gameBoard.position.y + gameBoard.size.height / 2 + 60
        let bottomHUDYPos = gameBoard.position.y - gameBoard.size.height / 2 - 60
        
        topHUD = HUD(reversed: true, parent: self, position: CGPoint(x: 0, y: topHUDYPos))
        bottomHUD = HUD(reversed: false, parent: self, position: CGPoint(x: 0, y: bottomHUDYPos))
        
        addChild(topHUD)
        addChild(bottomHUD)
    }
    
    private func updateHuds() {

        let scores = board.getScores()
        topHUD.update(whiteScore: scores.white, blackScore: scores.black, currentPlayer: board.currentPlayer)
        bottomHUD.update(whiteScore: scores.white, blackScore: scores.black, currentPlayer: board.currentPlayer)
    }
    
    private func setupStones() {
        
        board = Board()
        
        let offsetX = -295
        let offsetY = -290
        let stoneSize = 84
        
        for row in 0..<Board.size {
            
            var colArray = [Stone]()
            
            for col in 0..<Board.size {
                
                let stone = Stone(color: .clear, size: CGSize(width: stoneSize, height: stoneSize))
                
                stone.position = CGPoint(x: offsetX + col * stoneSize, y: offsetY + row * stoneSize)
                stone.zPosition = 3
                
                stone.row = row
                stone.col = col
                
                gameBoard.addChild(stone)
                colArray.append(stone)
            }
            
            board.rows.append([StoneColor](repeating: .empty, count: Board.size))
            
            rows.append(colArray)
        }
        
        setupInitialStones()
    }
    
    private func setupInitialStones() {
        
        rows[4][3].setPlayer(.white)
        rows[4][4].setPlayer(.black)
        rows[3][4].setPlayer(.white)
        rows[3][3].setPlayer(.black)
        
        board.rows[4][3] = .white
        board.rows[4][4] = .black
        board.rows[3][4] = .white
        board.rows[3][3] = .black
    }
    
    private func setupStrategist() {

        strategist = GKMonteCarloStrategist()

        strategist.budget = budgetForLevel()
        strategist.explorationParameter = 1
        strategist.randomSource = GKRandomSource.sharedRandom()
        strategist.gameModel = board
    }
    
    private func budgetForLevel() -> Int {
        if (gameMode == .vsEasyAI) {
            return 50
        } else if (gameMode == .vsNormalAI) {
            return 100
        }
        return 300
    }
    
    private func makeMove(row: Int, col: Int) {
        
        let captured = board.makeMove(currentPlayer: board.currentPlayer, row: row, col: col)
        
        let duration : TimeInterval = 0.2

        for move in captured {
            let stone = rows[move.row][move.col]
            animateCapturedStone(stone, duration: duration)
        }
        
        run(SFXSound.flip)
        updateHuds()
        passTurn()
    }
    
    private func passTurn() {
        
        board.currentPlayer = board.currentPlayer.opponent
        showPossibleMoves()
    }
    
    private func animateCapturedStone(_ stone: Stone, duration: TimeInterval) {

        let stoneColor = board.currentPlayer.stoneColor
        
        let scaleXDown = SKAction.scaleX(to: 0, duration: duration)
        let scaleXUp = SKAction.scaleX(to: 1, duration: duration)
        
        stone.run(SKAction.sequence([scaleXDown,
                               SKAction.run { stone.setPlayer(stoneColor) },
                               scaleXUp]))
    }
    
    
    private func clearPossibleMoves() {
    
        for row in 0..<Board.size {
            for col in 0..<Board.size {
                let stone = rows[row][col]
                if (stone.stoneColor == .whiteMark || stone.stoneColor == .blackMark) {
                    stone.setPlayer(.empty)
                }
            }
        }
    }
    
    private func showPossibleMoves() {
        
        clearPossibleMoves()
        
        let moves = board.getAvailableMoves()
        
        let mark : StoneColor = board.currentPlayer.stoneColor == .white ? .whiteMark : .blackMark
        
        moves.forEach {
            self.rows[$0.row][$0.col].setPlayer(mark)
        }
    }
    
    private func makeIAMove() {
                
        // Work to background thread.
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            
            // Current time
            let strategistTime = CFAbsoluteTimeGetCurrent()
            
            // Calculate the best move
            guard let move = self.strategist.bestMoveForActivePlayer() as? Move else { return }
            
            // Figure how much time the AI spent thinking
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            //print("Ai thinking time: \(delta)")
            
            // Set AI's chosen tile to the "thinking" texture
            DispatchQueue.main.async { [unowned self] in
                self.rows[move.row][move.col].setPlayer(.choice)
            }
            
            // Wait for at least 1 seconds
            let aiTimeCeiling = 1.0
            let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
            
            // After 3 seconds, make the move real
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [unowned self] in
                self.makeMove(row: move.row, col: move.col)
                self.checkIfGameOver()
            })
        }
    }
    
    private func checkIfGameOver() {
                
        if (board.getAvailableMoves().count == 0) {
            
            passTurn()
            
            if (board.getAvailableMoves().count == 0) {
                gameOver()
            }
        }

        if board.currentPlayer.stoneColor == .white && gameMode != .vsHuman {
            makeIAMove()
        }
    }
    
    private func gameOver() {
        run(SKAction.sequence([
                          SKAction.wait(forDuration: 2.0),
                          SKAction.run {
                              self.showGameOverMenu()
                          }]))
    }
}

extension GameScene: StoneTappedDelegate {

    func stoneTapped(_ stone: Stone) {
        
        let canMove = board.canMoveIn(row: stone.row, col: stone.col)
        let isIATurn = (gameMode != .vsHuman && board.currentPlayer.stoneColor == .white)
        
        if canMove && !isIATurn {
           
           makeMove(row: stone.row, col: stone.col)
           checkIfGameOver()
        }
            
        else {
           run(SFXSound.badMove)
        }
    }
}

extension GameScene {
   
    func showGameMenu() {
        addChild(GameOptionMenu(screenSize: self.size, delegate: self))
    }
    
    private func showGameOverMenu() {
        let scores = board.getScores()
        addChild(GameOverMenu(screenSize: self.size, delegate: self, blackScore: scores.black, whiteScore: scores.white))
    }
}

extension GameScene: GameOptionDelegate {
    
    func selectedOption(menuBox: MenuBox, option: GameOption) {
        switch(option) {
        case .continueGame: menuBox.removeFromParent()
        case .restartGame: restart()
        case .returnToMainMenu: mainMenu()
        }
    }
    
    private func restart() {
        let scene = GameScene(size: size)
        scene.gameMode = self.gameMode
        view?.presentScene(scene)
    }
    
    private func mainMenu() {
        let scene = MenuScene(size: size)
        view?.presentScene(scene)
    }
}
