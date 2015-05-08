//
//  MainScreen.swift
//  Elias of  Dereham
//
//  Created by apple on 08/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//

import Foundation
import SpriteKit

class MainScreen: SKScene {
    
override init(size: CGSize){
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        var background: SKSpriteNode
        background =  SKSpriteNode(imageNamed: "start")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        sceneTapped()
    }
    
    func sceneTapped(){
        let gameScene = GameScene(size: size)
        let reveal = SKTransition.crossFadeWithDuration(0.5)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: reveal)
        
    }

}