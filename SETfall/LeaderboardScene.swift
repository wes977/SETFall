//
//  LeaderboardScene.swift
//  SETfall
//
//  Created by Student on 2016-10-26.
//  Copyright © 2016 WesNet. All rights reserved.
//

//

import SpriteKit
// for showing the highscores
class LeaderboardScene: SKScene {
    
    var viewController: GameViewController!
    let backButton = SKSpriteNode(imageNamed:"back")
    let playButton = SKSpriteNode(imageNamed:"play")
    let titleText = SKLabelNode(fontNamed: "Chalkduster")
    let swipeRighttext = SKLabelNode(fontNamed: "Chalkduster")
    
    let leaderboard1Text = SKLabelNode(fontNamed: "Chalkduster")
    let leaderboard2Text = SKLabelNode(fontNamed: "Chalkduster")
    let leaderboard3Text = SKLabelNode(fontNamed: "Chalkduster")
    
    var leaderboardPanel = 0
    var maxNumPanels = 2
    var ranking = 1
    

    
    var lb = Leaderboard.sharedInstance
    // the init
    override func didMove(to view: SKView) {
        

        
        self.backButton.position = CGPoint(x: self.frame.midX * 0.5,y: self.frame.midY * 0.35)
        self.addChild(self.backButton)
        
        self.playButton.position = CGPoint(x: self.frame.midX * 1.5,y: self.frame.midY * 0.35)
        self.addChild(self.playButton)
        
        self.titleText.text = "Leaderboard"
        self.titleText.fontSize = 42
        self.titleText.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.75)
        
        self.leaderboard1Text.text = "-"
        self.leaderboard1Text.fontSize = 18
        self.leaderboard1Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.5)
        
        self.leaderboard2Text.text = "-"
        self.leaderboard2Text.fontSize = 18
        self.leaderboard2Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.25)
        
        self.leaderboard3Text.text = "-"
        self.leaderboard3Text.fontSize = 18
        self.leaderboard3Text.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1)
        
        
        
        self.swipeRighttext.text = "swipe up to go to next set"
        self.swipeRighttext.fontSize = 18
        self.swipeRighttext.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 0.75)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardScene.swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardScene.swipedDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        
        self.addChild(self.titleText)
        self.addChild(self.swipeRighttext)
        self.addChild(self.leaderboard1Text)
        self.addChild(self.leaderboard2Text)
        self.addChild(self.leaderboard3Text)
        
        self.backgroundColor = UIColor(hex: 0x80D9FF)
        
    }
// travering the leaderboard
    func swipedDown(_ sender:UISwipeGestureRecognizer){
        //lb.addScore(69, nName: "Wes Thompson")
        if leaderboardPanel != 0{
            leaderboardPanel -= 1
        }
        
    }
    // goign up in the leaderboard
    func swipedUp(_ sender:UISwipeGestureRecognizer){
     
        if leaderboardPanel != maxNumPanels{
            
            leaderboardPanel += 1
        }
        
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
    // the loop to update the leaderboard and all that 
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        let lboard = lb.getLeaderboard()
        let sortedKeys = Array(lboard.keys).sorted(by: >)
        var counter = 0
        
        for i in 0...(2){
            if lboard.count >= (ranking - 1)
            {
                let stepper = i + (leaderboardPanel * 3)
                if stepper < (lboard.count )
                {
                    let temp = lboard[sortedKeys[stepper]]
                    let tempScore = sortedKeys[stepper]
                    if counter == 0
                    {
                        self.leaderboard1Text.text = "\(stepper + 1). \(tempScore) : \(temp!)"
                        counter = 1
                        
                    }
                    else if counter == 1
                    {
                        self.leaderboard2Text.text = "\(stepper + 1). \(tempScore) : \(temp!)"
                        
                        counter = 2
                    }
                    else if counter == 2
                    {
                        self.leaderboard3Text.text = "\(stepper + 1). \(tempScore) : \(temp!)"
                        counter = 0
                    }
                    
                }
                else
                {
                    if counter == 0
                    {
                        self.leaderboard1Text.text = "--"
                        counter = 1
                        
                    }
                    else if counter == 1
                    {
                        self.leaderboard2Text.text = "--"
                        
                        counter = 2
                    }
                    else if counter == 2
                    {
                        self.leaderboard3Text.text = "--"
                        counter = 0
                    }
                }
            }
        }
       // self.leaderboard1Text.text = "\(lboard[order[0]])"
        
        
    }
}
