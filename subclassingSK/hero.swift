//
//  hero.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//

import UIKit
import SpriteKit

class hero: character,pTargetable {
    
    var health = 10  // define the values required by the protocols used ( pTargetable here )
    var weapon: pWeapon
    
    override init() {
        
        self.weapon = Gun()  // initializing the default weapon for our Hero
        
        super.init()   //  initialize the default values from the SuperClass ( character )
        
                                // override any values here
        scorePoints = 5         //change the default scorePoints from 1 to 5
        
        let texture = texturesPlayer
        let xSize = texture.size().width*scale                // Create The texture for the top ( visible sprite )
        let ySize = texture.size().height*scale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 1.0
        self.name = "hero"

        let top = SKSpriteNode(texture: texture, size: size)
        top.zPosition = layers.characters
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
                                                    // add the top sprite
        self.addChild(top)
        shoot()

          }

    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    func takeDamage(damage: Int) {
        health -= damage
        print("You lost \(damage) hit points")
        
        if health <= 0 {
            print("You are dead now")
            die()
        }
    }
    
    func shoot() {
        
        let newBullet = bulletHero()
        newBullet.position = CGPoint(x: 50, y: 0)
        self.addChild(newBullet)
        newBullet.physicsBody?.velocity = CGVector(dx: 250, dy: 0)
    }
    
    

}
