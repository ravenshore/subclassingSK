//
//  enemy.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/21/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//


import UIKit
import SpriteKit

class enemy: character,pTargetable {
    
    var health = 10  // define the values required by the protocols used ( pTargetable here )
    
    override init() {
        
        
        super.init()   //  initialize the default values from the SuperClass ( character )
        
        // override any values here
        scorePoints = 5         //change the default scorePoints from 1 to 5
        
        let texture = texturesEnemy
        let xSize = texture.size().width*scale                // Create The texture for the top ( visible sprite )
        let ySize = texture.size().height*scale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 1.0
        self.name = "hero"
        
        // COLLISION STUFF
        
        self.physicsBody?.categoryBitMask = bitMasks.enemy  // ship
        self.physicsBody?.collisionBitMask = bitMasks.projectileHero
        self.physicsBody?.contactTestBitMask = bitMasks.projectileHero

        
        let top = SKSpriteNode(texture: texture, size: size)
        top.zPosition = layers.characters
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite
        self.addChild(top)
        moveEnemy(50, who: self)
        
        let shooting: SKAction = shoot()
        self.runAction((shooting), withKey: "shoot")
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func takeDamage(damage: Int) {
        health -= damage
        print("Enemy lost \(damage) hit points")
        
        if health <= 0 {
            print("Enemy is dead now")
            die()
        }
    }
    
    func moveEnemy(speed: CGFloat, who: enemy) {
        
        let path = CGPathCreateMutable() // create a path
        
        CGPathMoveToPoint(path, nil, enemyPosition.x, enemyPosition.y) // starting position
        CGPathAddLineToPoint(path, nil, enemyPosition.x, frameH-(texturesEnemy.size().height)*scale)  // first point is the full height minus half of enemy's height
        CGPathAddLineToPoint(path, nil, enemyPosition.x, (texturesEnemy.size().height)*scale)  //second point
        CGPathAddLineToPoint(path, nil, enemyPosition.x, enemyPosition.y) // starting position
        
        let followLine = SKAction.followPath(path, asOffset: false, orientToPath: false, speed: speed)
        let repeatingFollow = SKAction.repeatActionForever(followLine)
        
        who.runAction(repeatingFollow) // run the Action on the enemys
    }
    
    func shootingRepeater()-> SKAction {
        let shooting = SKAction.runBlock { () -> Void in
            let newBullet = bulletEnemy()
            newBullet.position = CGPoint(x: spawnedEnemy.position.x-50 , y: spawnedEnemy.position.y)
            objectsLayer.addChild(newBullet)
            newBullet.physicsBody?.velocity = CGVector(dx: -250, dy: 0)
        }
        return shooting
    }
    
    func shoot() -> SKAction {
            
            let shootingDelay = SKAction.waitForDuration(2.3, withRange:2.0 )
            let rocketShootingSequence = SKAction.sequence([shootingRepeater(),shootingDelay])
            let shootingRepeatAction = SKAction.repeatActionForever(rocketShootingSequence)
            
            return shootingRepeatAction
        }
    
}
