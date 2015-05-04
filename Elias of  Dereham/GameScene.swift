//
//  GameScene.swift
//  Elias of  Dereham
//
//  Created by apple on 04/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var elias:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
    
    //setup world physics
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
    
    //ELIAS STUFF
        
    //load Elias image atlasin
    let atlas = SKTextureAtlas(named: "eliasimages")
        
    //walk cycle create an array of all the images
    var walkFrames = [AnyObject]()
        for i in 1 ... 8 {
            if let texture = atlas.textureNamed("elias00\(i)"){
            walkFrames.append(texture)
        }
    }
    
    //Create an Elias Sprite
    let elias = SKSpriteNode(texture: walkFrames[0] as SKTexture)
    elias.name = "Elias"
        
    //add physics to Elias
    elias.physicsBody = SKPhysicsBody(rectangleOfSize: elias.size)
    elias.physicsBody?.dynamic = true
    elias.physicsBody?.allowsRotation = false
    elias.physicsBody?.mass = 0.6
    elias.setScale(0.2)
    elias.position = CGPoint(x: 1800, y: 2000)
        
    //set up walking animation
        let walkAnimation = SKAction.animateWithTextures(walkFrames, timePerFrame: 0.1, resize: false, restore: false)
        let repeatAction = SKAction.repeatActionForever(walkAnimation)
        elias.runAction(repeatAction)
    
    //add elias
    self.addChild(elias)
        
        
    //GROUND
        let ground = SKSpriteNode(color: UIColor(white: 1.0, alpha: 0), size:CGSize(width: frame.size.width, height: 20))
        ground.position = CGPoint(x: self.frame.size.width/2, y: 450)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
        
        
        //BACKGROUND
        let background = SKTexture(imageNamed: "1")
        //cheap to draw(?)
        background.filteringMode = SKTextureFilteringMode.Nearest
        let bgSprite = SKSpriteNode(texture: background)
        bgSprite.size = frame.size
        bgSprite.position = CGPoint(x: frame.size.width/2.0, y: frame.size.height/2.0)
        bgSprite.zPosition = -10
        addChild(bgSprite)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            println("TOUCH")
            //Needs to be fixed
            //elias.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2000))
            
 
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
