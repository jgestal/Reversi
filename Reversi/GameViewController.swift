//
//  GameViewController.swift
//  Reversi
//
//  Created by Juan Gestal Romani on 25/11/2018.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupScene();
    }
    
    func setupScene() {
        
        guard let view = view as? SKView else { fatalError("No SKView") }

        let scene = MenuScene(size: CGSize(width: 768, height: 1024))
        let scale = 768 / view.frame.size.width;

        scene.setScale(scale)
        scene.scaleMode = .aspectFit
             
        view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
