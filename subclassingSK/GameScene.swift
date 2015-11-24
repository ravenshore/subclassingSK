//
//  GameScene.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright (c) 2015 Razvigor Andreev. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 45;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)
        
        gameScene = self
        setupLayers()
        setupBg()
        spawnedHero = spawnHero(heroPosition)
        spawnedEnemy = spawnEnemy(enemyPosition, level: 2)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let newHero = hero()
//            
//           newHero.position = location
//           let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//           newHero.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(newHero)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
    
    

}
