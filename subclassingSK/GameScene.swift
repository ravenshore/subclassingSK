//
//  GameScene.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright (c) 2015 Razvigor Andreev. All rights reserved.
//

import SpriteKit

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
    
    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 45;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
       
        gameScene = self
        setupLayers()
        setupBg()
        spawnedHero = spawnHero(heroPosition)
        spawnedEnemy = spawnEnemy(enemyPosition, level: 2)
        setupLabels()
        checkIfHit()
        
        
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
            if spawnedHero.health > 0 {
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

    
    
    

}
