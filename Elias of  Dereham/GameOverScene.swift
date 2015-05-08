//
//  GameOverScene.swift
//  Elias of  Dereham
//
//  Created by apple on 08/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let won: Bool
    
    init(size: CGSize, won: Bool){
        self.won = won
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        var background: SKSpriteNode
        if (won) {
            background = SKSpriteNode(imageNamed: "win")
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                //Play Sound
                ]))
        } else {
            background = SKSpriteNode(imageNamed: "fail")
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.5),
                //play Sound
                ]))
        }
    
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        
        let wait = SKAction.waitForDuration(3.0)
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.crossFadeWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(SKAction.sequence([wait, block]))
    }
}
