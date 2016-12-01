//
//  PlayScene.swift
//  SETfall
//
//  Created by Student on 2016-10-24.
//  Copyright © 2016 WesNet. All rights reserved.
//

import SpriteKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

// This is the games scene and all that jazz
class PlayScene : SKScene, SKPhysicsContactDelegate, UITextFieldDelegate
{
    var addStar = false
    var starOnscreen = false
    var bounce = true
    var pausedGame = false
    let numOfEnemies = 7
    var waterStart2 = CGFloat(0)
    var waterEnd2 = CGFloat(0)
    let runningBar = SKSpriteNode(imageNamed:"bar")
    let hero = SKSpriteNode(imageNamed:"hero")
    let pauseButton = SKSpriteNode(imageNamed:"barrel")
    let star = SKSpriteNode(imageNamed:"star")
    let block1 = SKSpriteNode(imageNamed:"fire")
    let villian = SKSpriteNode(imageNamed:"villian")
    let cannonBalls:[SKSpriteNode] = [SKSpriteNode(imageNamed:"cannonBall"),SKSpriteNode(imageNamed:"cannonBall")]
    let cannonBall = SKSpriteNode(imageNamed:"villian")
    let barrel = SKSpriteNode(imageNamed:"barrel")
    let BounceBarrel = SKSpriteNode(imageNamed:"barrel")
    let block2 = SKSpriteNode(imageNamed:"block2")
    let platform = SKSpriteNode(imageNamed:"block2")
    let platform2 = SKSpriteNode(imageNamed:"block2")
    let platform3 = SKSpriteNode(imageNamed:"block2")
    let platform4 = SKSpriteNode(imageNamed:"block2")
    let water = SKSpriteNode(imageNamed:"water")
    let water2 = SKSpriteNode(imageNamed:"water")
    let water3 = SKSpriteNode(imageNamed:"water")
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    let timerText = SKLabelNode(fontNamed: "Chalkduster")
    var playerName = ""
    var bounceHeight = CGFloat(400)
    let leaderboardButton = SKSpriteNode(imageNamed:"leaderboard")
    var addTime = false
    let submitScoreText = SKLabelNode(fontNamed: "Chalkduster")
    let submitScoreTextShadow = SKLabelNode(fontNamed: "Chalkduster")
    var Up1 = true
    var Up2 = false
    var Up3 = true
    var Up4 = false
    var starsCollected = 0.0
    var origRunningBarPositionX = CGFloat(0)
    var maxBarX = CGFloat(0)
    var groundSpeed = 5
    var heroBaseLine = CGFloat(0)
    var onGround = true
    var velocityY = CGFloat(0)
    var gravity = CGFloat(0.5)
    var blockMaxX = CGFloat(0)
    var origBlockPositionX = CGFloat(0)
    var score = 0
    var moveRight = false
    var moveLeft = false
    
    var startTime = TimeInterval()
    var timer = Timer()
    var gameTime:Double = 30
    var randomTime = 20
    var gameOver = false
    var onPlatfrom = false
    var blockStatuses:Dictionary<String,BlockStatus> = [:]
    var enemySelection = UInt32(1)
    var groundMoving = false
    var villianMoveRight = false
    var villianMoveCounter = 0
    enum ColliderType:UInt32{
        case hero = 1
        case block = 2
        case platform = 3
        case star = 4
    }
    
    var highScoreText: UITextField!
    
    
    // when we move to this view and all that so the init method
    override func didMove(to view: SKView) {
        
        
        
        
        // Mark: Timer stuff
        let aSelector : Selector = #selector(PlayScene.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        
        // Mark: background Color
        self.backgroundColor = UIColor(hex:0x80D9FF)
        
        
        //Mark: setting up the ground stuff
        self.runningBar.anchorPoint = CGPoint(x: 0,y: 0.5)
        self.runningBar.position = CGPoint(x: self.frame.minX,y: self.frame.minY + (self.runningBar.size.height / 2))
        self.origRunningBarPositionX = self.runningBar.position.x
        
        self.maxBarX = self.runningBar.size.width - self.frame.size.width
        self.maxBarX *= -1
        
        self.heroBaseLine = self.runningBar.position.y + (self.runningBar.size.height / 2 ) + (self.hero.size.height / 2) // This is setting the hero to above the running bar
        self.hero.position = CGPoint(x: self.frame.minX + self.hero.size.width + (self.hero.size.width / 2) , y: self.heroBaseLine) // This is setting the inti X position
        
        // Mark: Physics Stuff
        self.physicsWorld.contactDelegate = self
        
        // Mark: Hero physics stuff
        self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width / 2))
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.block.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        //Mark: setting the blocks position of the screen
        
        self.block1.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        self.pauseButton.position = CGPoint(x: self.frame.maxX - self.block1.size.width, y: self.frame.maxY - self.block1.size.width)
        self.block2.position = CGPoint(x: self.frame.maxX + self.block2.size.width, y: self.heroBaseLine + (self.block1.size.height / 2))
        self.villian.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        self.cannonBall.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        self.barrel.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        self.BounceBarrel.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        self.water.position = CGPoint(x: self.frame.maxX + self.water.size.width, y: self.frame.minY + (self.water.size.height / 2) + 1)
        self.water2.position = CGPoint(x: self.frame.maxX + self.water.size.width, y: self.frame.minY + (self.water.size.height / 2) + 1)
        self.water3.position = CGPoint(x: self.frame.maxX + self.water.size.width, y: self.frame.minY + (self.water.size.height / 2) + 1)
        self.star.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        self.platform.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
        self.platform.zRotation = 1.571// rotate 90 degrees
        self.platform2.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
        self.platform2.zRotation = 1.571// rotate 90 degrees
        self.platform3.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
        self.platform3.zRotation = 1.571// rotate 90 degrees
        self.platform4.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
        self.platform4.zRotation = 1.571// rotate 90 degrees
        var counterCB = CGFloat(0)
        for (cb) in cannonBalls {
            cb.position = CGPoint(x: self.frame.maxX + self.block1.size.width , y: self.frame.maxY + cb.size.height)
            // Mark: obcstacle physics stuff
            cb.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
            cb.physicsBody?.isDynamic = false
            cb.physicsBody?.categoryBitMask = ColliderType.block.rawValue
            cb.physicsBody?.collisionBitMask = ColliderType.block.rawValue
            self.addChild(cb)
            counterCB += 1
            // self.cb.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
        }
        
        // Mark: obcstacle physics stuff
        self.block1.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.block1.physicsBody?.isDynamic = false
        self.block1.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.block1.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        
        self.star.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.star.physicsBody?.isDynamic = false
        self.star.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.star.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        self.villian.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.villian.physicsBody?.isDynamic = false
        self.villian.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.villian.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        self.cannonBall.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.cannonBall.physicsBody?.isDynamic = false
        self.cannonBall.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.cannonBall.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        
        self.block2.physicsBody = SKPhysicsBody(rectangleOf: self.block2.size)
        self.block2.physicsBody?.isDynamic = false
        self.block2.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.block2.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        self.barrel.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.barrel.physicsBody?.isDynamic = false
        self.barrel.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.barrel.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        self.BounceBarrel.physicsBody = SKPhysicsBody(rectangleOf: self.block1.size)
        self.BounceBarrel.physicsBody?.isDynamic = false
        self.BounceBarrel.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.BounceBarrel.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        
        self.water.physicsBody = SKPhysicsBody(rectangleOf: self.water.size)
        self.water.physicsBody?.isDynamic = false
        self.water.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.water.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        self.water.zPosition = 1
        
        self.water2.physicsBody = SKPhysicsBody(rectangleOf: self.water.size)
        self.water2.physicsBody?.isDynamic = false
        self.water2.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.water2.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        self.water2.zPosition = 1
        
        self.water3.physicsBody = SKPhysicsBody(rectangleOf: self.water.size)
        self.water3.physicsBody?.isDynamic = false
        self.water3.physicsBody?.categoryBitMask = ColliderType.block.rawValue
        self.water3.physicsBody?.collisionBitMask = ColliderType.block.rawValue
        self.water3.zPosition = 1
        
        self.platform.physicsBody = SKPhysicsBody(rectangleOf: self.platform.size )
        self.platform.physicsBody?.isDynamic = false
        self.platform.physicsBody?.categoryBitMask = ColliderType.platform.rawValue
        self.platform.physicsBody?.collisionBitMask = ColliderType.platform.rawValue
        
        self.platform2.physicsBody = SKPhysicsBody(rectangleOf: self.block2.size)
        self.platform2.physicsBody?.isDynamic = false
        self.platform2.physicsBody?.categoryBitMask = ColliderType.platform.rawValue
        self.platform2.physicsBody?.collisionBitMask = ColliderType.platform.rawValue
        
        self.platform3.physicsBody = SKPhysicsBody(rectangleOf: self.block2.size)
        self.platform3.physicsBody?.isDynamic = false
        self.platform3.physicsBody?.categoryBitMask = ColliderType.platform.rawValue
        self.platform3.physicsBody?.collisionBitMask = ColliderType.platform.rawValue
        
        self.platform4.physicsBody = SKPhysicsBody(rectangleOf: self.block2.size)
        self.platform4.physicsBody?.isDynamic = false
        self.platform4.physicsBody?.categoryBitMask = ColliderType.platform.rawValue
        self.platform4.physicsBody?.collisionBitMask = ColliderType.platform.rawValue
        
        self.star.physicsBody?.accessibilityLabel = "star"
        
        self.origBlockPositionX = self.block1.position.x
        
        self.block1.name  = "fire"
        self.block2.name = "block2"
        self.villian.name  = "villian"
        self.barrel.name  = "barrel"
        self.cannonBall.name  = "cannonBall"
        self.BounceBarrel.name  = "BounceBarrel"
        self.water.name = "water"
        self.water2.name = "water2"
        self.water3.name = "water3"
        self.star.name = "star"
        self.blockMaxX = 0 - self.block1.size.width / 2
        
        
        blockStatuses["fire"] = BlockStatus(isRunning: false, ntimeGapNextRun: random(), ncurrentInterval: UInt32(0),enemyType: UInt32(1))
        blockStatuses["block2"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(2))
        blockStatuses["villian"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(3))
        blockStatuses["BounceBarrel"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(4))
        blockStatuses["barrel"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(5))
        blockStatuses["water"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(6))
        blockStatuses["water2"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(7))
        blockStatuses["water3"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(8))
        blockStatuses["cannonBall"] = BlockStatus(isRunning:false ,ntimeGapNextRun: random(),ncurrentInterval: UInt32(0),enemyType: UInt32(9))
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 42
        self.scoreText.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.75)
        
        self.timerText.text = "0"
        self.timerText.fontSize = 42
        self.timerText.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.50)
        
        self.leaderboardButton.position = CGPoint(x: self.frame.midX * 1.5,y: self.frame.midY * 0.5)
        
        self.addChild(self.platform)
        self.addChild(self.platform2)
        self.addChild(self.platform3)
        self.addChild(self.platform4)
        self.addChild(self.runningBar)
        self.addChild(hero)
        self.addChild(block1)
        self.addChild(block2)
        self.addChild(villian)
        self.addChild(cannonBall)
        self.addChild(barrel)
        self.addChild(BounceBarrel)
        self.addChild(scoreText)
        self.addChild(timerText)
        self.addChild(water)
        self.addChild(water2)
        self.addChild(water3)
        self.addChild(self.star)
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayScene.swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
    }
    
    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        highScoreText.removeFromSuperview()
        let lbScene = LeaderboardScene(size: self.size)
        
        // Populates the SKLabelNode
        playerName = textField.text!
        lbScene.lb.addScore(score,  nName: playerName)
        
        // Hides the keyboard
        textField.resignFirstResponder()
        
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        lbScene.scaleMode = .resizeFill
        lbScene.size = skView.bounds.size
        skView.presentScene(lbScene)
        
        return true
        
    }
    // This is for the timer to keep track of it and all
    func updateTime() {
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        var elapsedTime = currentTime - startTime
        let seconds = gameTime - elapsedTime
        if addTime {
            starsCollected += starsCollected
            startTime = startTime + 5
            addTime = false
        }
        if seconds > 0 {
            elapsedTime += TimeInterval(seconds)
            self.timerText.text = "Time: \(Int(seconds))"
            
        } else {
            timer.invalidate()
            died()
        }
    }
    //MARK: contact stuff when one things hits another
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.collisionBitMask == ColliderType.block.rawValue
        {
            if contact.bodyA.accessibilityLabel == "star"
            {
                addTime = true
                addStar = false
                self.removeChildren(in: [star])
                self.star.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine)
                
                
                self.addChild(self.star)
            }
            else{
                died()
            }
            
            
        }
        else if contact.bodyA.collisionBitMask == ColliderType.platform.rawValue
        {
            onPlatfrom = true
            
        }
        
        
    }
    //MARK: contact stuff when one things stops hitting another
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.collisionBitMask == ColliderType.platform.rawValue
        {
            onPlatfrom = false
            
            
        }
        
        
    }
    // When the player dies
    func died()
    {
        gameOver = true
        
        highScoreText = UITextField(frame: CGRect(x: view!.bounds.width / 2 - 160, y: view!.bounds.height / 3 - 20, width: 320, height: 40))
        highScoreText.delegate = self
        
        highScoreText.borderStyle = UITextBorderStyle.roundedRect
        highScoreText.textColor = SKColor.black
        highScoreText.placeholder = "Enter your name here"
        highScoreText.backgroundColor = SKColor.white
        highScoreText.keyboardType = UIKeyboardType.default
        
        highScoreText.clearButtonMode = UITextFieldViewMode.whileEditing
        highScoreText.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        self.view!.addSubview(highScoreText)
        
        submitScoreText.fontSize = 32
        submitScoreText.position = CGPoint(x: size.width / 2, y: size.height * 0.9)
        submitScoreText.text = "Enter your name for the leaderboard"
        addChild(submitScoreText)
        timer.invalidate()
        self.removeChildren(in: [scoreText])
        self.removeChildren(in: [timerText])
        
        
    }
    // get a random number
    func random() -> UInt32{
        let range = UInt32(50)..<UInt32(200)
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1)
    }
    // get a random number in a range
    func randomRange(min: UInt32,max: UInt32) -> UInt32{
        let range = min..<max
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1)
    }
    // pick a random enemy
    func randomEnemy() -> UInt32{
        let range = UInt32(1)..<UInt32(7)
        return range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1)
    }
    // When the player swipes up   jump and all that
    func swipedUp(_ sender:UISwipeGestureRecognizer){
        print("swiped up")
        
        
        // This is for jumping
        if self.onGround {
            self.velocityY = -18.0
            self.onGround = false
        }
    }
    // when you touch the screen any where
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = (touches.first! ).location(in: self.view)
        if self.atPoint(location) == self.pauseButton{
            
            self.pausedGame = true
        }
        if gameOver == false{
            
            if location.x < self.view!.bounds.size.width / 2 {
                print("Move left")
                // left code
                // Move the ground
                moveLeft = true
                
            } else {
                print("Move Right")
                moveRight = true
            }
        }
        else if gameOver == true
        {
            if self.atPoint(location) == self.leaderboardButton{
                let scene = LeaderboardScene(size: self.size)
                
                scene.lb.addScore(score, nName: playerName)
                
                let skView = self.view! as SKView
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .resizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene)
                
            }
        }
    }
    // when you stop touching the scren you animal
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if moveRight == true {
            moveRight = false
        }
        if moveLeft == true {
            moveLeft = false
        }
        
        // This is for jumping
        if self.velocityY < -9.0{
            self.velocityY = -9.0
            
        }
    }
    // this is basically the game loop
    override func update(_ currentTime: TimeInterval) {
        if gameOver == false
        {
            
            // This is for
            if  self.runningBar.position.x <= maxBarX {
                self.runningBar.position.x = self.origRunningBarPositionX
                self.score += 1
                if score % 4  == 0
                {
                    addStar = true
                }
                
                self.scoreText.text = "Score: \(String(self.score))"
                
            }
            
            // Mark: Hero Jump
            if onPlatfrom == false
            {
                self.velocityY += self.gravity
                self.hero.position.y -= velocityY
            }
            
            
            
            
            if self.hero.position.y < self.heroBaseLine{
                self.hero.position.y = heroBaseLine
                self.velocityY = 0.0
                self.onGround = true
                self.onPlatfrom = false
            }
            if onPlatfrom == true
            {
                
                
                self.onGround = true
                
            }
            else
            {
                onPlatfrom = false
            }
            
            // MARK: Hero movement
            if moveLeft == true{
                if self.hero.position.x > (self.frame.minX + self.hero.size.width + (self.hero.size.width / 2))
                {
                    self.hero.position.x -= CGFloat(self.groundSpeed)
                    // Rotate Hero
                    let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                    self.hero.zRotation += CGFloat(degreeRotation)
                }
            }
            if moveRight == true{
                if self.hero.position.x < self.frame.midX
                {
                    self.hero.position.x += CGFloat(self.groundSpeed)
                    groundMoving = false
                }
                else
                {
                    runningBar.position.x -= CGFloat(self.groundSpeed)
                    groundMoving = true
                }
                
                // Rotate Hero
                let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                self.hero.zRotation -= CGFloat(degreeRotation)
            }
            cannonballFaller()
            enemyRunner()
            
            
            if addStar == true  {
                starRunner()
            }
            
        }
        
    }
    // adding stars since 1969 for more time
    func starRunner() {
        if star.position.x > blockMaxX // if block is not done running continue
        {
            if moveRight == true // if player is moving right move the block
            {
                star.position.x -= CGFloat(self.groundSpeed)
            }
        }
        else // move to back to origanal spot
        {
            
            star.position.x =  self.frame.maxX + star.size.width
            addStar = false
            //self.score += 1
            if ((self.score % 5) == 0)
            {
                self.groundSpeed += 1
            }
            self.scoreText.text = "Score: \(String(self.score))"
        }
    }
    // adding cannonballs that fall from the sky for no fucking reason
    func cannonballFaller() {
        for cBall in cannonBalls {
            if cBall.position.y > self.frame.minY // if block is not done running continue
            {
                if moveRight == true // if player is moving right move the block
                {
                    cBall.position.x -= CGFloat(self.groundSpeed)
                }
                
                cBall.position.y -= CGFloat(self.groundSpeed)
                
            }
            else // move to back to origanal spot
            {
                cBall.position.x = CGFloat(randomRange(min: (UInt32(frame.minX)), max: UInt32(frame.maxX)))
                cBall.position.y = self.frame.maxY + cBall.size.height
                
            }
        }
    }
    // spawning thesee mother fuckers
    func enemyRunner() {
        
        
        for (block, BlockStatus) in self.blockStatuses // this is how it add two blocks
        {
            
            if enemySelection == BlockStatus.enemy
            {
                
                let thisBlock = self.childNode(withName: block) // setting up the this block
                if BlockStatus.shouldRunBlock(){ // if it is all good to run
                    BlockStatus.timeGapForNextRun = random() // random position on the thing determined by time
                    BlockStatus.currentInterval = 0 // reset the thing to 0
                    BlockStatus.isRunning = true// saying ya run a block
                    
                }
                
                if BlockStatus.isRunning // if block is currently running
                {
                    
                    
                    
                    if BlockStatus.enemy == 1
                    {
                        if thisBlock?.position.x > blockMaxX // if block is not done running continue
                        {
                            if moveRight == true // if player is moving right move the block
                            {
                                thisBlock?.position.x -= CGFloat(self.groundSpeed)
                            }
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.origBlockPositionX
                            BlockStatus.isRunning = false
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    else if BlockStatus.enemy == 2
                    {
                        if thisBlock?.position.x > blockMaxX // if block is not done running continue
                        {
                            if moveRight == true // if player is moving right move the block
                            {
                                thisBlock?.position.x -= CGFloat(self.groundSpeed)
                            }
                            
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.origBlockPositionX
                            BlockStatus.isRunning = false
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    else if BlockStatus.enemy == 3 // MARK: Villian controls
                    {
                        if thisBlock?.position.x > blockMaxX // if block is not done running continue
                        {
                            
                            if villianMoveCounter == 0
                            {
                                if thisBlock?.position.x < (blockMaxX + 50){
                                    villianMoveRight = true
                                    villianMoveCounter += 1
                                }
                            }
                            if thisBlock?.position.x > self.frame.maxX{
                                villianMoveRight = false
                            }
                            if villianMoveRight{
                                thisBlock?.position.x += CGFloat(self.groundSpeed)
                                // Rotate Hero
                                let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                                thisBlock?.zRotation -= CGFloat(degreeRotation)
                            }
                            else{
                                thisBlock?.position.x -= CGFloat(self.groundSpeed)
                                // Rotate Hero
                                let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                                thisBlock?.zRotation += CGFloat(degreeRotation)
                            }
                            
                            
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.origBlockPositionX
                            BlockStatus.isRunning = false
                            villianMoveCounter = 0
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    else if BlockStatus.enemy == 4 // MARK: Bouncing barrel
                    {
                        
                        
                        if thisBlock?.position.x > blockMaxX // if block is not done running continue
                        {
                            if bounceHeight > 10
                            {
                                
                                
                                if (thisBlock?.position.y < heroBaseLine)
                                {
                                    bounce = false
                                    bounceHeight = bounceHeight * 0.75
                                }
                                else if thisBlock?.position.y > bounceHeight
                                {
                                    bounce = true
                                }
                                
                                if bounce
                                {
                                    thisBlock?.position.y -= CGFloat(self.groundSpeed)
                                }
                                else
                                {
                                    thisBlock?.position.y += CGFloat(self.groundSpeed)
                                }
                            }
                            thisBlock?.position.x -= CGFloat(self.groundSpeed)
                            // Rotate Hero
                            let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                            thisBlock?.zRotation += CGFloat(degreeRotation)
                            
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.origBlockPositionX
                            thisBlock?.position.y = self.heroBaseLine
                            BlockStatus.isRunning = false
                            bounceHeight = CGFloat(randomRange(min: 150, max: 400))
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    else if BlockStatus.enemy == 5 // MARK: nonBouncing Barrel
                    {
                        if thisBlock?.position.x > blockMaxX // if block is not done running continue
                        {
                            thisBlock?.position.x -= CGFloat(self.groundSpeed)
                            // Rotate Hero
                            let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                            thisBlock?.zRotation += CGFloat(degreeRotation)
                            
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.origBlockPositionX
                            BlockStatus.isRunning = false
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    else if BlockStatus.enemy == 6 // MARK: Water hazard 1
                    {
                        waterStart2 = (thisBlock?.position.x)! - (water.size.width) / 2
                        waterEnd2 = (thisBlock?.position.x)! + (water.size.width) / 2
                        
                        if (thisBlock?.position.x)! + self.water.size.width > blockMaxX // if block is not done running continue
                        {
                            if moveRight == true // if player is moving right move the block
                            {
                                thisBlock?.position.x -= CGFloat(self.groundSpeed)
                                platform.position.x =  waterStart2 + platform.size.width / 2
                                platform2.position.x = waterStart2 + water.size.width / 3 + platform.size.width / 2
                                platform3.position.x = waterEnd2 - water.size.width / 3 + platform.size.width / 2
                                platform4.position.x = waterEnd2 - platform.size.width / 2
                            }
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.frame.maxX + self.water.size.width // reseting the water to off the screen
                            BlockStatus.isRunning = false
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            //self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    else if BlockStatus.enemy == 7 // MARK: Water hazard 2 Up and down plat forms
                    {
                        
                        waterStart2 = (thisBlock?.position.x)! - (water2.size.width) / 2
                        waterEnd2 = (thisBlock?.position.x)! + (water2.size.width) / 2
                        
                        waterStart2 = (thisBlock?.position.x)!  - (water2.size.width) / 2
                        waterEnd2 = (thisBlock?.position.x)! + (water2.size.width) / 2
                        
                        if (thisBlock?.position.x)! + self.water.size.width > blockMaxX // if block is not done running continue
                        {
                            if moveRight == true // if player is moving right move the block
                            {
                                thisBlock?.position.x -= CGFloat(self.groundSpeed)
                                platform.position.x = waterStart2 + platform.size.width / 2
                                platform2.position.x = waterStart2 + water.size.width / 3 + platform.size.width / 2
                                platform3.position.x = waterEnd2 - water.size.width / 3 + platform.size.width / 2
                                platform4.position.x = waterEnd2 - platform.size.width / 2
                            }
                            
                            
                            if platform.position.y > (self.frame.maxY - hero.size.height * 2){
                                Up1 = false
                                
                            }
                            
                            if platform.position.y < self.frame.minY{
                                Up1 = true
                            }
                            if Up1{
                                platform.position.y += CGFloat(self.groundSpeed)
                                
                            }
                            else{
                                platform.position.y -= CGFloat(self.groundSpeed)
                                
                            }
                            
                            if platform2.position.y > (self.frame.maxY - hero.size.height * 2){
                                Up2 = false
                                
                            }
                            
                            if platform2.position.y < self.frame.minY{
                                Up2 = true
                            }
                            if Up2{
                                platform2.position.y += CGFloat(self.groundSpeed)
                                
                            }
                            else{
                                platform2.position.y -= CGFloat(self.groundSpeed)
                                
                            }
                            
                            if platform3.position.y > (self.frame.maxY - hero.size.height * 2){
                                Up3 = false
                                
                            }
                            
                            if platform3.position.y < self.frame.minY{
                                Up3 = true
                            }
                            if Up3{
                                platform3.position.y += CGFloat(self.groundSpeed)
                                
                            }
                            else{
                                platform3.position.y -= CGFloat(self.groundSpeed)
                                
                            }
                            
                            if platform4.position.y > (self.frame.maxY - hero.size.height * 2){
                                Up4 = false
                                
                            }
                            
                            if platform4.position.y < self.frame.minY{
                                Up4 = true
                            }
                            if Up4{
                                platform4.position.y += CGFloat(self.groundSpeed)
                                
                            }
                            else{
                                platform4.position.y -= CGFloat(self.groundSpeed)
                                
                            }
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.x = self.frame.maxX + self.water.size.width // reseting the water to off the screen
                            BlockStatus.isRunning = false
                            self.platform.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
                            
                            self.platform2.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
                            
                            self.platform3.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
                            
                            self.platform4.position = CGPoint(x: self.frame.maxX + self.block1.size.width, y: self.heroBaseLine + (self.block1.size.height / 2) )
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            //self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    if BlockStatus.enemy == 9 // MARK: nonBouncing Barrel
                    {
                        if thisBlock?.position.x > blockMaxX // if block is not done running continue
                        {
                            thisBlock?.position.x -= CGFloat(self.groundSpeed)
                            // Rotate Hero
                            let degreeRotation = CDouble(self.groundSpeed) * M_PI / 180
                            thisBlock?.zRotation += CGFloat(degreeRotation)
                            
                        }
                        else // move to back to origanal spot
                        {
                            enemySelection = randomEnemy()
                            thisBlock?.position.y = CGFloat(randomRange(min: (UInt32(frame.minY)), max: UInt32(frame.maxY)))
                            thisBlock?.position.x = self.origBlockPositionX
                            BlockStatus.isRunning = false
                            //self.score += 1
                            if ((self.score % 5) == 0)
                            {
                                self.groundSpeed += 1
                            }
                            self.scoreText.text = "Score: \(String(self.score))"
                        }
                    }
                    
                }
                    
                    
                else { // if not running set up another one
                    BlockStatus.currentInterval += 1
                    
                }
            }
            
            
        }
    }
    
    
}
