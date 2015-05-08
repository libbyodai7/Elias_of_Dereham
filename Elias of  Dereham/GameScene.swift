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
    
    //creates an array of the objects
    var objects = [Object]()
    
    //variables needed for object movement
    let objectMovePointsPerSec: CGFloat = 35
    
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
    addObject()
    
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
    
        moveObjects()
    

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
        elias.setScale(0.25)
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
        let ground = SKSpriteNode(color: UIColor(white: 1.0, alpha: 0), size:CGSize(width: 47104, height: 20))
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
    
    
//OBJECT NODE
//iterates through objects and calls them sequntially (allows objcts to be placed offscreen)
    func objectNode() -> SKSpriteNode{
        let objectNode = SKSpriteNode()
        objectNode.anchorPoint = CGPointZero
        objectNode.zPosition = 0
        
        //creates instances of each object
        var o1  = Object(position: CGPoint(x: 8350, y: 500), texture: SKTexture(imageNamed: "waterWheel"))
        o1.setScale(0.5)
        objectNode.addChild(o1)
        
        var o2  = Object(position: CGPoint(x: 10864, y: 500), texture: SKTexture(imageNamed: "barrel1"))
        objectNode.addChild(o2)
        
        var o3  = Object(position: CGPoint(x: 11556, y: 500), texture: SKTexture(imageNamed: "barrel2"))
        objectNode.addChild(o3)
        
        var o4  = Object(position: CGPoint(x: 12002, y: 500), texture: SKTexture(imageNamed: "moneyBag"))
        objectNode.addChild(o4)
        
        var o4a  = Object(position: CGPoint(x: 13000, y: 500), texture: SKTexture(imageNamed: "moneyBag"))
        objectNode.addChild(o4a)
        
        var o4b  = Object(position: CGPoint(x: 13200, y: 500), texture: SKTexture(imageNamed: "moneyBag"))
        objectNode.addChild(o4b)
        
        var o5  = Object(position: CGPoint(x: 13584, y: 500), texture: SKTexture(imageNamed: "moneyBagPile"))
        objectNode.addChild(o5)
        
        var o6  = Object(position: CGPoint(x: 14034, y: 500), texture: SKTexture(imageNamed: "Sherrif"))
        o6.setScale(0.7)
        objectNode.addChild(o6)
        
        var o7  = Object(position: CGPoint(x: 15000, y: 500), texture: SKTexture(imageNamed: "prisonCart"))
        objectNode.addChild(o7)
        
        var o8  = Object(position: CGPoint(x: 15800, y: 500), texture: SKTexture(imageNamed: "crate"))
        objectNode.addChild(o8)
        
        var o8a  = Object(position: CGPoint(x: 16000, y: 500), texture: SKTexture(imageNamed: "crate"))
        objectNode.addChild(o8a)
        
        var o8b  = Object(position: CGPoint(x: 17000, y: 500), texture: SKTexture(imageNamed: "crate"))
        objectNode.addChild(o8b)
        
        var o9  = Object(position: CGPoint(x: 17426, y: 500), texture: SKTexture(imageNamed: "barrel1"))
        objectNode.addChild(o9)
        
        var o10  = Object(position: CGPoint(x: 18000, y: 500), texture: SKTexture(imageNamed: "trapDoor"))
        objectNode.addChild(o10)
        
        var o11  = Object(position: CGPoint(x: 18918, y: 500), texture: SKTexture(imageNamed: "p10o1"))
        objectNode.addChild(o11)
        
        var o12  = Object(position: CGPoint(x: 19510, y: 500), texture: SKTexture(imageNamed: "p10o2"))
        objectNode.addChild(o12)
        
        var o13  = Object(position: CGPoint(x: 20090, y: 500), texture: SKTexture(imageNamed: "p10o3"))
        objectNode.addChild(o13)
        
        var o14  = Object(position: CGPoint(x: 20876, y: 500), texture: SKTexture(imageNamed: "barrel1"))
        objectNode.addChild(o14)
        
        var o15  = Object(position: CGPoint(x: 21401, y: 500), texture: SKTexture(imageNamed: "barrel2"))
        objectNode.addChild(o15)
        
        var o16  = Object(position: CGPoint(x: 21577, y: 500), texture: SKTexture(imageNamed: "p11o3"))
        objectNode.addChild(o16)
        
        var o17  = Object(position: CGPoint(x: 23435, y: 500), texture: SKTexture(imageNamed: "p12o1"))
        o17.setScale(2)
        objectNode.addChild(o17)
        
        var o18  = Object(position: CGPoint(x: 27000, y: 500), texture: SKTexture(imageNamed: "p12o3"))
        objectNode.addChild(o18)
        
        var o19  = Object(position: CGPoint(x: 27400, y: 500), texture: SKTexture(imageNamed: "p14o2"))
        objectNode.addChild(o19)
        
        var o20  = Object(position: CGPoint(x: 28112, y: 500), texture: SKTexture(imageNamed: "p14o3"))
        objectNode.addChild(o20)
        
        var o21  = Object(position: CGPoint(x: 29300, y: 500), texture: SKTexture(imageNamed: "stones"))
        objectNode.addChild(o21)
        
        var o22  = Object(position: CGPoint(x: 29730, y: 500), texture: SKTexture(imageNamed: "stones"))
        objectNode.addChild(o22)
        
        var o23  = Object(position: CGPoint(x: 30000, y: 500), texture: SKTexture(imageNamed: "p15o3"))
        objectNode.addChild(o23)
        
        var o24  = Object(position: CGPoint(x: 31700, y: 500), texture: SKTexture(imageNamed: "fence"))
        objectNode.addChild(o24)
        
        var o25  = Object(position: CGPoint(x: 32200, y: 500), texture: SKTexture(imageNamed: "fence"))
        objectNode.addChild(o25)
        
        var o26  = Object(position: CGPoint(x: 35846, y: 500), texture: SKTexture(imageNamed: "fence"))
        objectNode.addChild(o26)
        
        var o27  = Object(position: CGPoint(x: 37846, y: 500), texture: SKTexture(imageNamed: "sheep1"))
        objectNode.addChild(o27)
        
        var o28  = Object(position: CGPoint(x: 38346, y: 500), texture: SKTexture(imageNamed: "sheep1"))
        objectNode.addChild(o28)
        
        var o29  = Object(position: CGPoint(x: 38846, y: 500), texture: SKTexture(imageNamed: "sheep1"))
        objectNode.addChild(o29)
        
        var o30  = Object(position: CGPoint(x: 39346, y: 500), texture: SKTexture(imageNamed: "sheep1"))
        objectNode.addChild(o30)

        objectNode.size = CGSize(width: 47104, height: 1536)
        return objectNode
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
    
//SCROLL OBJECTS
//scrolls objects in the scene
    func moveObjects(){
        enumerateChildNodesWithName("object")
            { node, _ in
                let object = node as SKSpriteNode
                let objectVelocity  = CGPoint(x: -self.backgroundMovePointsPerSec, y: 0)
                let amountToMove = objectVelocity * CGFloat(self.dt)
                object.position += amountToMove
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

//OBJECT
//function to add object to scene
    func addObject(){
        
        let object = objectNode()
        object.anchorPoint = CGPointZero
        object.position = CGPointZero
        object.zPosition = 0 // puts img at the back
        object.name = "object"
        addChild(object)
    }
    
//JUMPING FUNCTION
//only works if Elias is under a certain y position
    func eliasJump(){
        if elias.position.y < 650 {
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


