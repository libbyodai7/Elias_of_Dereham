//
//  GameScene.swift
//  Elias of  Dereham
//
//  Created by apple on 04/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //Elias variable
    var elias:SKSpriteNode!
    
    //variables needed for smooth scrolling
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let backgroundMovePointsPerSec: CGFloat = 200

    
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
    elias.setScale(0.3)
    elias.position = CGPoint(x: 500, y: 500)
        
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
        let background = backgroundNode()
        backgroundColor = SKColor.whiteColor() // loads default white background
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        background.zPosition = -1 // puts img at the back
        background.name = "background"
        addChild(background)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            println("TOUCH")
            //Needs to be fixed
            //elias.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
            
 
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        
        moveBackground()
        
        //moveSprite(elias, velocity: CGPoint(x: 100, y: 0))
        

    }
    
    
    func backgroundNode() -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        //anchor point is the pivot point
        // 0 point it bottom left
        backgroundNode.anchorPoint = CGPointZero
        
        //adds in each background sequentially
        for i in 1  ... 23{
            let pixelPosition = (i * 2048) - 2048
            let i = SKSpriteNode(imageNamed: "\(i)")
            i.anchorPoint = CGPointZero
            i.position = CGPoint(x: pixelPosition, y: 0)
            backgroundNode.addChild(i)
            
        }
        
        
        //function completion
        backgroundNode.size = CGSize(width: 47104, height: 1536)
        return backgroundNode
        
        
    }
    
    
    func moveBackground(){
        enumerateChildNodesWithName("background") { node, _ in
            let background = node as SKSpriteNode
            let backgroundVelocity  = CGPoint(x: -self.backgroundMovePointsPerSec, y: 0)
            let amountToMove = backgroundVelocity * CGFloat(self.dt)
            background.position += amountToMove
        }
    }
    
}
