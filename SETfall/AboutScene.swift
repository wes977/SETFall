//
//  AboutScene.swift
//  SETfall
//
//  Created by Student on 2016-10-26.
//  Copyright © 2016 WesNet. All rights reserved.
//
//
//  GameScene.swift
//  SETfall
//
//  Created by Student on 2016-10-24.
//  Copyright (c) 2016 WesNet. All rights reserved.
//

import SpriteKit
// The about page
class AboutScene: SKScene {
    

    // all the buttons YEEEEEEEEEEEEE
    let backButton = SKSpriteNode(imageNamed:"back")
    let playButton = SKSpriteNode(imageNamed:"play")
    
    let titleText = SKLabelNode(fontNamed: "Chalkduster")
    let about1Text = SKLabelNode(fontNamed: "Chalkduster")
    let about2Text = SKLabelNode(fontNamed: "Chalkduster")
    let about3Text = SKLabelNode(fontNamed: "Chalkduster")
    

    // the init
    override func didMove(to view: SKView) {
        
        self.backButton.position = CGPoint(x: self.frame.midX * 0.5,y: self.frame.midY * 0.35)
        self.addChild(self.backButton)
        
        self.playButton.position = CGPoint(x: self.frame.midX * 1.5,y: self.frame.midY * 0.35)
        self.addChild(self.playButton)
        
        self.titleText.text = "SetFall"
        self.titleText.fontSize = 42
        self.titleText.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.75)
        
        self.about1Text.text = "Wesley Thompson 6992143"
        self.about1Text.fontSize = 18
        self.about1Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.5)
        
        self.about2Text.text = "Jen Klimova"
        self.about2Text.fontSize = 18
        self.about2Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.25)
        
        self.about3Text.text = "G-Dev with Russ"
        self.about3Text.fontSize = 18
        self.about3Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1)
        

        
        
        self.addChild(self.titleText)
        self.addChild(self.about1Text)
        self.addChild(self.about2Text)
        self.addChild(self.about3Text)
        
        print("went to instruction page")
        
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
    }
    // when you touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.location(in: self)
            if self.atPoint(location) == self.backButton{
                let scene = GameScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
            
            if self.atPoint(location) == self.playButton{
                let scene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
        }
    }
    // the lopp i dont need 
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
