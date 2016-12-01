//
//  InstructionScene.swift
//  SETfall
//
//  Created by Student on 2016-10-26.
//  Copyright © 2016 WesNet. All rights reserved.
//

//

import SpriteKit
// the instruction screen also know as the tutoriel for some reason i just dont know
class InstructionScene: SKScene {
    
    let backButton = SKSpriteNode(imageNamed:"back")
    let playButton = SKSpriteNode(imageNamed:"play")
    let titleText = SKLabelNode(fontNamed: "Chalkduster")
    let swipeRighttext = SKLabelNode(fontNamed: "Chalkduster")
    
    let instruction1Text = SKLabelNode(fontNamed: "Chalkduster")
    let instruction2Text = SKLabelNode(fontNamed: "Chalkduster")
    let instruction3Text = SKLabelNode(fontNamed: "Chalkduster")

    var instructionPanel = 0
    var maxNumPanels = 2
    // the inti
    override func didMove(to view: SKView) {
        
        self.backButton.position = CGPoint(x: self.frame.midX * 0.5,y: self.frame.midY * 0.35)
        self.addChild(self.backButton)
        
        self.playButton.position = CGPoint(x: self.frame.midX * 1.5,y: self.frame.midY * 0.35)
        self.addChild(self.playButton)
        
        self.titleText.text = "Instructions: Controls"
        self.titleText.fontSize = 42
        self.titleText.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.75)
        
        self.instruction1Text.text = "Tap the left half the screen to go left"
        self.instruction1Text.fontSize = 18
        self.instruction1Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.5)
        
        self.instruction2Text.text = "Tap the right half the screen to go right"
        self.instruction2Text.fontSize = 18
        self.instruction2Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.25)
        
        self.instruction3Text.text = "swipe up to jump"
        self.instruction3Text.fontSize = 18
        self.instruction3Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1)
        

        
        self.swipeRighttext.text = "swipe right to go to next panel."
        self.swipeRighttext.fontSize = 18
        self.swipeRighttext.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.75)
        
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(InstructionScene.swipedRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(InstructionScene.swipedLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        
        self.addChild(self.titleText)
        self.addChild(self.swipeRighttext)
        self.addChild(self.instruction1Text)
        self.addChild(self.instruction2Text)
        self.addChild(self.instruction3Text)

        print("went to instruction page")
        
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
    }
    //swiped right and all that
    func swipedRight(_ sender:UISwipeGestureRecognizer){
        if instructionPanel != 0{
            instructionPanel -= 1
        }
        
    }
    //swiped left and all that
    func swipedLeft(_ sender:UISwipeGestureRecognizer){
        if instructionPanel != maxNumPanels{
            instructionPanel += 1
        }
        
    }
    // started touching it
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
    // the loop to update things 
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if instructionPanel == 0{
            self.titleText.text = "Instructions: Controls"
            self.instruction1Text.text = "Tap the left half the screen to go left"
            self.instruction2Text.text = "Tap the right half the screen to go right"
            self.instruction3Text.text = "swipe up to jump"
        }
        else if instructionPanel == 1{
            self.titleText.text = "Instructions: Enemies"
            self.instruction1Text.text = "jump over fire, scorpions, logs"
            self.instruction2Text.text = "Jump onto the crocidiles heads when they are closed to get across the pond"
            self.instruction3Text.text = "jump onto the vines to cross the tarpits"
        }
        else if instructionPanel == 2{
            self.titleText.text = "Instructions: Points"
            self.instruction1Text.text = "You get points for crossing obstacles"
            self.instruction2Text.text = "The amount of time it takes you to get those points"
            self.instruction3Text.text = "Try to reach the top spot on the leaderboard"
        }
        
        if instructionPanel == 0{
                self.swipeRighttext.text = "swipe left to go to next panel."
        }
        else if instructionPanel == maxNumPanels{
                self.swipeRighttext.text = "swipe right to go to next panel."
        }
        else {
                self.swipeRighttext.text = "swipe left to go to next panel and right to go back a panel"
        }
        
    }
}
