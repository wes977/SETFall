//
//  GameScene.swift
//  SETfall
//
//  Created by Student on 2016-10-24.
//  Copyright (c) 2016 WesNet. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed:"play")
    let aboutButton = SKSpriteNode(imageNamed:"about")
    let instructionButton = SKSpriteNode(imageNamed:"tutoriel")
    let leaderboardButton = SKSpriteNode(imageNamed:"leaderboard")
    
    override func didMove(to view: SKView) {
        
        
        self.playButton.position = CGPoint(x: self.frame.midX * 0.5,y: self.frame.midY * 1.5)
        self.addChild(self.playButton)
        
        self.aboutButton.position = CGPoint(x: self.frame.midX * 0.5,y: self.frame.midY * 0.5)
        self.addChild(self.aboutButton)
        
        self.instructionButton.position = CGPoint(x: self.frame.midX * 1.5,y: self.frame.midY * 1.5)
        self.addChild(self.instructionButton)
        
        self.leaderboardButton.position = CGPoint(x: self.frame.midX * 1.5,y: self.frame.midY * 0.5)
        self.addChild(self.leaderboardButton)
        
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.location(in: self)
            
            if self.atPoint(location) == self.playButton{
                let scene = PlayScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
            }
            
            if self.atPoint(location) == self.aboutButton{
                let scene = AboutScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
            if self.atPoint(location) == self.instructionButton{
                let scene = InstructionScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
            
            if self.atPoint(location) == self.leaderboardButton{
                let scene = LeaderboardScene(size: self.size)
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
        }
           }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
