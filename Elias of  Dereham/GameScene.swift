//
//  GameScene.swift
//  Elias of  Dereham
//
//  Created by apple on 04/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//


///make it so when elias hits finish category he wins and lose category he looses
//make proper object class


import SpriteKit

//bitwise operators to allow player to contact different obstacles and for that to have different effects
let playerCategory: UInt32 = 1 << 0
let groundCategory: UInt32 = 1 << 1
let objectCategory: UInt32 = 1 << 2
let finishCategory: UInt32 = 1 << 3
let loseCategory: UInt32 = 1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Elias variable
    var elias:SKSpriteNode!
    
    //variables needed for smooth scrolling
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let backgroundMovePointsPerSec: CGFloat = 200

    
override func didMoveToView(view: SKView) {
    
    //setup world physics
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
    physicsWorld.contactDelegate = self
    
    //add in player
    addElias()
   
    //add in Ground
    addGround()
    
    //need a floor for first section too
    
    //add in background
    addBackground()
    
    //Add in objects
    spawnObject()
    
    //Add in Finish
    addFinishLine()
    
    //Add in Death Line
        
    
    
    }
    
    //jumping feature (needs work)
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        //needs to make it so player can only jump once elias is on ground
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            println("TOUCH")
            elias.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600))
            
 
        }
    }
  
//update function
override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    
    //function to ensure animations are consitent if frames are dropped
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        //update functions called here
        moveBackground()
    

    }
    
    
//ELIAS 
//function to add Elias
    func addElias(){
        
        //load Elias image atlas in
        let atlas = SKTextureAtlas(named: "eliasimages")
        
        //walk cycle create an array of all the images
        var walkFrames = [AnyObject]()
        for i in 1 ... 8 {
            if let texture = atlas.textureNamed("elias00\(i)"){
                walkFrames.append(texture)
            }
        }
        
        
        //Create an Elias Sprite
        elias = SKSpriteNode(texture: walkFrames[0] as SKTexture)
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
        
        //bitmask operators
        elias.physicsBody?.categoryBitMask = playerCategory
        elias.physicsBody?.collisionBitMask = groundCategory | objectCategory | finishCategory
        elias.physicsBody?.contactTestBitMask = groundCategory | objectCategory | finishCategory
        
        //add elias
        addChild(elias)
    }
    
//GROUND
//Function to add ground
    func addGround(){
        let ground = SKSpriteNode(color: UIColor(white: 1.0, alpha: 0), size:CGSize(width: frame.size.width, height: 20))
        ground.name = "ground"
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.dynamic = false
        
        ground.physicsBody?.categoryBitMask = groundCategory
        ground.physicsBody?.collisionBitMask = playerCategory | objectCategory | finishCategory
    
        ground.position = CGPoint(x: self.frame.size.width/2, y: 450)
        addChild(ground)
    }
    
    
 //BACKGROUND NODE
//function to iterate through the backgrounds and call them in place
func backgroundNode() -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPointZero
        backgroundNode.zPosition = -1
        
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
    
 //SCROLL BACKGROUND
//scrolls the background
func moveBackground(){
        enumerateChildNodesWithName("background")
            { node, _ in
            let background = node as SKSpriteNode
            let backgroundVelocity  = CGPoint(x: -self.backgroundMovePointsPerSec, y: 0)
            let amountToMove = backgroundVelocity * CGFloat(self.dt)
            background.position += amountToMove
            }
        }

//BACKGROUND (uses backgroundNode function to iterate through backgrounds)
//function to add background
    func addBackground(){
        
        let background = backgroundNode()
        backgroundColor = SKColor.whiteColor() // loads default white background
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        background.zPosition = -1 // puts img at the back
        background.name = "background"
        addChild(background)
    }

//OBJECT SPAWN
 //function to spawn objcts (needs work)
func spawnObject(){
        //barrel
        let barrel = SKSpriteNode(imageNamed: "barrel1")
        barrel.name = "barrel"
        barrel.physicsBody = SKPhysicsBody(rectangleOfSize: barrel.size)
        barrel.physicsBody?.dynamic = true
        barrel.physicsBody?.allowsRotation = false
    
        barrel.physicsBody?.categoryBitMask = objectCategory
        barrel.physicsBody?.collisionBitMask = playerCategory | groundCategory
    
        barrel.position = CGPoint(x: 1000, y: 500)
        barrel.zPosition = 0
        addChild(barrel)
    
        //moves objects with screen (needs fixing)
        let actionMove = SKAction.moveTo(CGPoint(x: -barrel.size.width/2, y: barrel.position.y), duration: 5.5)
        barrel.runAction(actionMove)
    }
    
    
//FINISH LINE
    func addFinishLine(){
        
        let finish = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 5.0, height: frame.height))
        finish.name = "finish"
        finish.physicsBody = SKPhysicsBody(rectangleOfSize: finish.size)
        finish.physicsBody?.dynamic = false
        finish.physicsBody?.allowsRotation = false
        finish.physicsBody?.categoryBitMask = finishCategory
        finish.physicsBody?.collisionBitMask = playerCategory
        finish.position = CGPoint(x: 47000, y:frame.height*0.5)
        finish.zPosition = 0
        addChild(finish)
    }
    
    
//LOSE GAME LINE
    

    
//CHECK COLLISION .. TO FINISH
//function to check any collision
// add in object that is always behind start of screen.. if elias connects with that game over
    func didBeginContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask & objectCategory) == objectCategory ||
            (contact.bodyB.categoryBitMask & objectCategory) == objectCategory {
                NSLog("hit object")
        }
        
        if (contact.bodyA.categoryBitMask & groundCategory) == groundCategory ||
            (contact.bodyB.categoryBitMask & groundCategory) == groundCategory {
                NSLog("Elias can jump")
        }
       
            }
    

 //GAME END
//game end funciton (needs work)
func gameEnd(didWin:Bool) {
        if didWin {
            NSLog("You Won")
        } else {
        NSLog("You lost")
        }
    }

}


