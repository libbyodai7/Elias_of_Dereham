//
//  Object.swift
//  Elias of  Dereham
//
//  Created by apple on 06/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//

import Foundation
import SpriteKit

//OBJECT CLASS
//Provides a framework for all the interactable objects in the scene

class Object: SKSpriteNode {
    
    //required initializers
    required init (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //initialisers, allows position texture and name to be inputted
    init(position: CGPoint, texture: SKTexture, name: String) {
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        self.position = position
        self.name = "object"
        
        //physics for all the obejcts
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.allowsRotation = false
        self.zPosition = 0
        self.physicsBody?.categoryBitMask = objectCategory
        self.physicsBody?.collisionBitMask = playerCategory | groundCategory
        
        //scrolls objects with the scene
        let actionMove = SKAction.moveTo(CGPoint(x: -self.size.width/2, y: self.position.y), duration: 5.5)
        self.runAction(actionMove)

    }
    
   
}