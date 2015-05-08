//
//  GameViewController.swift
//  Elias of  Dereham
//
//  Created by apple on 04/05/2015.
//  Copyright (c) 2015 Group 7. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController{
    
    override func viewDidLoad(){
    super.viewDidLoad()
    
    
    //Setup Sprite kit View
    let view = self.view as SKView
    let scene = MainScreen(size:CGSize(width: 2048, height: 1536))
    view.showsFPS = true
    view.showsNodeCount = true
    view.ignoresSiblingOrder = true
    scene.scaleMode = .AspectFill
    view.presentScene(scene)
    
    //Starts music
    //SoundManager.playBackgroundMusic()
}

    override func prefersStatusBarHidden() -> Bool {
        return true
}

}


