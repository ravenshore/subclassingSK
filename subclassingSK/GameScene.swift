//
//  GameScene.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright (c) 2015 Razvigor Andreev. All rights reserved.
//

import SpriteKit
import AVFoundation

func distanceBetweenPoints(first: CGPoint, second: CGPoint)-> CGFloat {
    return hypot(second.x - first.x, second.y - first.y);
}

var gameOver: Bool = false


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var healthHero = SKLabelNode(text: "Hero HP: 10")
    var healthEnemy = SKLabelNode(text: "Enemy HP: 10")
    var restartLabel = SKLabelNode(text: "RESTART")
    var shootLabel = SKLabelNode(text: "SHOOT")
    var objectsToRemove = [SKNode]()
    var shootingAllowed: Bool = true
    var bgMusicPlayer: AVAudioPlayer!
    var audioPlayer: AVAudioPlayer!
    
    override func didMoveToView(view: SKView) {

        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, -3.0)
        
        
        gameScene = self
        setupLayers()
//        setupBg()
        callStars()
        spawnedHero = spawnHero(heroPosition)
        spawnedEnemy = spawnEnemy(enemyPosition, level: 2)
        setupLabels()
        checkIfHit()
        playMusic("musicBg.m4a", loops: -1)
//        callRed()
        spawnAsteroids()
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first as UITouch! {
            
            let location = touch.locationInNode(self)
            
            if restartLabel .containsPoint(location) && gameOver {
                
                restartGame()
            }
            if shootLabel .containsPoint(location) && shootingAllowed == true && !gameOver {
                
                spawnedHero.shoot()
                shootingAllowed = false
                shootLabel.fontColor = redColor
                delay(2.0, closure: { () -> () in
                    
                    self.shootingAllowed = true
                    self.shootLabel.fontColor = blueColor
                })
            }
            
            if !gameOver {
                
                let distanceX = location.x - spawnedHero.position.x
                let distanceY = location.y - spawnedHero.position.y
                let newLocation = CGPoint(x: location.x, y: location.y + 50)
                
                let distance = CGFloat(sqrt(distanceX*distanceX + distanceY*distanceY))
                let speed: CGFloat = 250
                let time = distance / speed
                let timeToTravelDistance = NSTimeInterval(time)
                let duration: NSTimeInterval = timeToTravelDistance
                
                let move = SKAction.moveTo(newLocation, duration: duration)
                move.timingMode = SKActionTimingMode.EaseInEaseOut
                spawnedHero.runAction(move)
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first as UITouch! {
            let location = touch.locationInNode(self)
            
            if !gameOver {
                
                let distanceX = location.x - spawnedHero.position.x
                let distanceY = location.y - spawnedHero.position.y
                let newLocation = CGPoint(x: location.x, y: location.y + 50)
                
                let distance = CGFloat(sqrt(distanceX*distanceX + distanceY*distanceY))
                let speed: CGFloat = 250
                let time = distance / speed
                let timeToTravelDistance = NSTimeInterval(time)
                let duration: NSTimeInterval = timeToTravelDistance
                let move = SKAction.moveTo(newLocation, duration: duration)
                move.timingMode = SKActionTimingMode.Linear
                spawnedHero.runAction(move)
                }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        
        cleaning()
        
    }
    
    func spawnHero(at: CGPoint)-> hero {
        
        let newHero = hero()
        newHero.position = at
        objectsLayer.addChild(newHero)
        
        
        return newHero
    }
    
    func spawnEnemy(at: CGPoint, level: Int)-> enemy {
        
        let newEnemy = enemy()
        newEnemy.position = at
        newEnemy.health = 10 + level*3
        objectsLayer.addChild(newEnemy)
        
        return newEnemy
    }
    
    func setupLayers() {
        
        objectsLayer = SKNode()
        objectsLayer.name = "Objects Layer"
        //        objectsLayer.frame == CGRect(x: 0, y: 0, width: screenW, height: screenH)
        addChild(objectsLayer)
    }
    
    func setupBg() {
        
        let bg = SKSpriteNode(texture: texturesBg, color: UIColor.blackColor(), size: CGSize(width: frameW, height: frameH))
        bg.position = CGPoint(x: frameW / 2, y: frameH / 2)
        bg.zPosition = layers.background
        self.addChild(bg)
    }
    
    
    //  CONTACT        CONTACT              CONTACT                     CONTACT
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        if contact.bodyA.categoryBitMask == bitMasks.hero && contact.bodyB.categoryBitMask == bitMasks.projectileEnemy || contact.bodyB.categoryBitMask == bitMasks.hero && contact.bodyA.categoryBitMask == bitMasks.projectileEnemy {
            
            explosion1(contact.contactPoint)
            
            if let projectileBody = contact.bodyA.node as? projectile {                 // body A is the Asteroid
                projectileBody.physicsBody?.categoryBitMask = bitMasks.noContact
                objectsToRemove.append(projectileBody)
                print("body A")
                
            } else {
                if let projectileBody = contact.bodyB.node as? projectile {                 // body B is the Asteroid
                    projectileBody.physicsBody?.categoryBitMask = bitMasks.noContact
                    objectsToRemove.append(projectileBody)
                    print("body B")
                }
            }
            print("Hero got hit by a projectile !!!")
            spawnedHero.takeDamage(1)
           if !gameOver {
                healthHero.text = "Hero HP: \(spawnedHero.health)" }
            else {
                healthHero.text = "Hero is Dead :/"
                objectsLayer.addChild(restartLabel)
            }
            
        }
    }
    
    func cleaning() {
        
        objectsLayer.removeChildrenInArray(objectsToRemove)    // remove all Nodes marked for removal
        
        objectsLayer.enumerateChildNodesWithName("projectileEnemy", usingBlock: { bullet, stop in
            
            if bullet.position.y < 0 || bullet.position.y > frameH || bullet.position.x < 0 || bullet.position.x > frameW {
                
                self.objectsToRemove.append(bullet)
                
            }
            }
        )
        objectsLayer.enumerateChildNodesWithName("projectileHero", usingBlock: { bullet, stop in
            
            if bullet.position.y < 0 || bullet.position.y > frameH || bullet.position.x < 0 || bullet.position.x > frameW {
                
                self.objectsToRemove.append(bullet)
                
            }
            }
        )
    }
    
    func displayScore(at: CGPoint, score: Int) {
        
        
        let scoreLabel = SKLabelNode(text: String(score))
        scoreLabel.position = at
        var labelColor: SKColor!
        if score <= 1 {
            labelColor = whiteColor
        } else if score <= 5 {
            labelColor = blueColor
            
        } else {
            labelColor = redColor
            
        }
        
        
        
        
    }
    
    func setupLabels() {
        
        healthHero.position = CGPoint(x: 100, y: 150)
        healthHero.fontColor = whiteColor
        healthHero.fontName = "Copperplate"
        healthHero.text = "Hero HP: \(spawnedHero.health)"
        healthHero.fontSize = 22
        healthHero.zPosition = layers.projectiles
        objectsLayer.addChild(healthHero)
        
        healthEnemy.position = CGPoint(x: frameW - 100, y: 150)
        healthEnemy.fontColor = whiteColor
        healthEnemy.fontName = "Copperplate"
        healthEnemy.text = "Enemy HP: \(spawnedEnemy.health)"
        healthEnemy.fontSize = 22
        healthEnemy.zPosition = layers.projectiles
        objectsLayer.addChild(healthEnemy)
        
        restartLabel.position = CGPoint(x: frameW/2, y: 100)
        restartLabel.fontColor = whiteColor
        restartLabel.fontName = "Copperplate"
        restartLabel.text = "RESTART"
        restartLabel.fontSize = 35
        restartLabel.zPosition = layers.projectiles
        
        shootLabel.position = CGPoint(x: frameW/2, y: 125)
        shootLabel.fontColor = blueColor
        shootLabel.fontName = "Copperplate"
        shootLabel.text = "SHOOT"
        shootLabel.fontSize = 35
        shootLabel.zPosition = layers.projectiles
        objectsLayer.addChild(shootLabel)
        
        
    }
    
    func restartGame() {
        
        objectsLayer.removeAllChildren()
        spawnedHero = spawnHero(heroPosition)
        spawnedEnemy = spawnEnemy(enemyPosition, level: 2)
        setupLabels()
        shootingAllowed = true
        gameOver = false
        bgMusicPlayer.stop()
        playMusic("musicBg.m4a", loops: -1)
        callRed()
        
    }
    
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
        
    }
    
    func checkIfHit() {
        
        let checkAction = SKAction.runBlock { () -> Void in
            
            if gameOver {
                self.shootLabel.removeFromParent()
            }
            
            objectsLayer.enumerateChildNodesWithName("projectileHero", usingBlock: { bullet, stop in
                
                let distance = distanceBetweenPoints(spawnedEnemy.position, second: bullet.position)
                print("Distance is: \(distance)")
                if distance < 100 {
                    self.explosion1(bullet.position)
                    self.objectsToRemove.append(bullet)
                    print("Enemy got Hit")
                    spawnedEnemy.takeDamage(4)
                    if !gameOver {
                        self.healthEnemy.text = "Enemy HP: \(spawnedEnemy.health)" }
                    else  {
                        self.healthEnemy.text = "Enemy is Dead :)"
                        objectsLayer.addChild(self.restartLabel)
                    }
                }
                }
            )
        }
        
        let delayAction = SKAction.waitForDuration(0.5)
        let sequenceAction = SKAction.sequence([checkAction,delayAction])
        let sequenceRepeater = SKAction.repeatActionForever(sequenceAction)
        objectsLayer.runAction(sequenceRepeater)
    }
    
    func explosion1(atPoint: CGPoint) {
        
        audioHit()
        let explosion = SKEmitterNode(fileNamed: "explosion1")!
        explosion.position = atPoint
        explosion.name = "explosion1"
        explosion.xScale = 0.4
        explosion.yScale = 0.4
        explosion.zPosition = 10
        objectsLayer.addChild(explosion)
        delay(0.2) {
            self.objectsToRemove.append(explosion)
        }
        
    }
    func callStars() {
        
        let stars = SKEmitterNode(fileNamed: "stars.sks")!
        stars.position = CGPoint(x: frameW/2, y: frameH/2)
        stars.name = "stars1"
        stars.zPosition = 1
        self.addChild(stars)
        
    }
    
    func playMusic(filename: String, loops: Int) {
        let url = NSBundle.mainBundle().URLForResource(
            filename, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(filename)")
            return
        }
        var error: NSError? = nil
        
        do {
            bgMusicPlayer =
                try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            bgMusicPlayer = nil
        }
        if bgMusicPlayer == nil {
            print("Could not create audio player: \(error!)")
            return
        }
        
        bgMusicPlayer.numberOfLoops = loops
        bgMusicPlayer.prepareToPlay()
        bgMusicPlayer.play()
    }

    func audioHit() {
        
        let action = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)
        self.runAction(action, withKey: "hitAudio")
        
    }
    
    func callRed() {
        
        let startY = frameH   // point A
        let endY = self.frame.origin.y - 100   // point B
        
        let redAsteroid = SKSpriteNode(texture: textureAsteroidRed)
        redAsteroid.position = CGPoint(x: (screenW / 2) - 100, y: 0)
        redAsteroid.zPosition = layers.paralax
        self.addChild(redAsteroid)
        let path = CGPathCreateMutable()   // create a path
        
        CGPathMoveToPoint(path, nil, 0, startY) // path is at our point A
        CGPathAddLineToPoint(path, nil, 0, endY)  // add the second point B to our path
        

        let followLine = SKAction.followPath(path, asOffset: true, orientToPath: false, duration: 10)   // create the follow path action
        
        redAsteroid.runAction(followLine)  // run the action on our Red Asteroid

    }
    
    func spawnAsteroids() {
        
        let asteroidCreateAction = SKAction.runBlock { () -> Void in
            
            var randomAsteroid = SKSpriteNode()  //create empty SpriteNode
            let randomSizeFactor = self.randomFloatBetweenNumbers(0.3, secondNum: 1.0) // get a random Float
            let grey1Size = CGSize(width: grey1Width*randomSizeFactor, height: grey1Height*randomSizeFactor) // random size for grey1
            let grey2Size = CGSize(width: grey2Width*randomSizeFactor, height: grey2Height*randomSizeFactor) // random size for grey2
            let redSize = CGSize(width: redWidth*randomSizeFactor, height: redHeight*randomSizeFactor) // random size for red
            
            switch self.randomIntBetweenNumbers(1, secondNum: 3) { // set it's texture randomly
            case 1 :
                randomAsteroid = SKSpriteNode(texture: textureAsteroidRed, size: redSize)
                
            case 2:
                randomAsteroid = SKSpriteNode(texture: textureAsteroidGrey1, size: grey1Size)
                
            default:
                randomAsteroid = SKSpriteNode(texture: textureAsteroidGrey2, size: grey2Size)
            }

            let randomPositionX = self.randomIntBetweenNumbers(0, secondNum: Int(frameW))

            randomAsteroid.position = CGPoint(x: randomPositionX, y: Int(frameH) + 100)
            randomAsteroid.zPosition = layers.paralax // Yes, I added another layer, named Paralax ( it's 1 )
            randomAsteroid.physicsBody = SKPhysicsBody(circleOfRadius: 10*randomSizeFactor)
            randomAsteroid.physicsBody?.affectedByGravity = true
            randomAsteroid.physicsBody?.collisionBitMask = bitMasks.noContact
            randomAsteroid.name = "asteroid"  // set the name to remove them later
            objectsLayer.addChild(randomAsteroid)
                                                                                    // Add Random Rotation
            let randomRotateInt = self.randomIntBetweenNumbers(0, secondNum: 1)
            if randomRotateInt == 1 {
                randomAsteroid.runAction(repeatLeftRotate)
            } else {
                randomAsteroid.runAction(repeatRightRotate)
            }
       
            
        }
        let asteroidWaitAction = SKAction.waitForDuration(3, withRange: 2)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreateAction,asteroidWaitAction])
        let asteroidRepeatAction = SKAction.repeatActionForever(asteroidSequenceAction)
        
        objectsLayer.runAction(asteroidRepeatAction, withKey: "asteroidSpawner")
        
    }
    
    func randomIntBetweenNumbers(firstNum: Int, secondNum: Int) -> Int{
        return firstNum + Int(arc4random_uniform(UInt32(secondNum - firstNum + 1)))
    }
    
    func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}
