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
    
    //Object Variable
    var object: Object!
    
    //variables needed for smooth scrolling
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let backgroundMovePointsPerSec: CGFloat = 200
    
    //variable to see if Elias can Jump
    var jumpable: Bool = false
    
    
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
    addLoseLine()
    
    
    }
    
    //jumping feature (needs work)
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        //needs to make it so player can only jump once elias is on ground
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            println("TOUCH")
            
            eliasJump()
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
        elias.setScale(0.2)
        elias.position = CGPoint(x: 500, y: 500)
        
        //set up walking animation
        let walkAnimation = SKAction.animateWithTextures(walkFrames, timePerFrame: 0.1, resize: false, restore: false)
        let repeatAction = SKAction.repeatActionForever(walkAnimation)
        elias.runAction(repeatAction)
        
        //bitmask operators
        elias.physicsBody?.categoryBitMask = playerCategory
        elias.physicsBody?.collisionBitMask = groundCategory | objectCategory | finishCategory | loseCategory
        elias.physicsBody?.contactTestBitMask = groundCategory | objectCategory | finishCategory | loseCategory
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
 //function to spawn objects (needs work)
func spawnObject(){
      object = Object(position: CGPoint(x: 1000, y: 500), texture: SKTexture(imageNamed: "barrel1"), name: "barrel")
        addChild(object)
    }
    
//JUMPING FUNCTION
//only works if Elias is under a certain y position
    func eliasJump(){
        if elias.position.y < 600 {
        elias.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600))
        }
    }
    
    
//FINISH LINE
//to be joined with win screen
    func addFinishLine(){
        
        let finish = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 100, height: frame.height))
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
// to be joined with death screen
func addLoseLine(){
        
        let lose = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 100, height: frame.height))
        lose.name = "lose"
        lose.physicsBody = SKPhysicsBody(rectangleOfSize: lose.size)
        lose.physicsBody?.dynamic = false
        lose.physicsBody?.allowsRotation = false
        lose.physicsBody?.categoryBitMask = finishCategory
        lose.physicsBody?.collisionBitMask = playerCategory
        lose.position = CGPoint(x: -100, y:frame.height*0.5)
        lose.zPosition = 0
        addChild(lose)
    }

    
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
                jumpable = true
        } else {
            jumpable = false
        }
        
        if (contact.bodyA.categoryBitMask & finishCategory) == finishCategory ||
            (contact.bodyB.categoryBitMask & finishCategory) == finishCategory {
                gameEnd(false)
        }
        
        if (contact.bodyA.categoryBitMask & loseCategory) == loseCategory ||
            (contact.bodyB.categoryBitMask & loseCategory) == loseCategory {
                gameEnd(true)
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


