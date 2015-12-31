//
//  projectile.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/22/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//


import UIKit
import SpriteKit

class projectile: SKNode {
    
    override init() {
        super.init()   //  initialize the default values from the SuperClass ( SKNode )
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTop(withTexture: SKTexture) {   // Function for adding the visible texture
        
        let xSize = withTexture.size().width*scale             // Create The texture for the top ( visible sprite )
        let ySize = withTexture.size().height*scale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: withTexture, size: size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 0.1
        self.physicsBody?.categoryBitMask = 0x1 << 0
        let top = SKSpriteNode(texture: withTexture, size: size)
        top.zPosition = layers.projectiles                        // set zPosition
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite to the SKNode
        self.addChild(top)
    }
}

class bulletEnemy: projectile {
    
    var texture: SKTexture!
    
    override init() {
        super.init()
            self.name = "projectileEnemy"
            self.addTop(texturesBullet2)
        // COLLISION STUFF
        
        self.physicsBody?.categoryBitMask = bitMasks.projectileEnemy  // ship
        self.physicsBody?.collisionBitMask = bitMasks.noContact
        self.physicsBody?.contactTestBitMask = bitMasks.hero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class bulletHero: projectile {
    
    var texture: SKTexture!
    
    override init() {
        super.init()
            self.name = "projectileHero"
            self.addTop(texturesBullet1)
        // COLLISION STUFF
        
        self.physicsBody?.categoryBitMask = bitMasks.projectileHero  // ship
        self.physicsBody?.collisionBitMask = bitMasks.noContact
        self.physicsBody?.contactTestBitMask = bitMasks.enemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

