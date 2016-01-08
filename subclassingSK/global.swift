//
//  global.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//

import Foundation
import SpriteKit
                                                                            // TEXTURES

let texturesPlayer = SKTexture(imageNamed: "player.png")
let texturesEnemy = SKTexture(imageNamed: "enemy.png")
let texturesBullet1 = SKTexture(imageNamed: "bullet1.png")
let texturesBullet2 = SKTexture(imageNamed: "bullet2.png")
let texturesBg = SKTexture(imageNamed: "bg.png")

let textureAsteroidRed = SKTexture(imageNamed: "red.png")
let textureAsteroidGrey1 = SKTexture(imageNamed: "grey1.png")
let textureAsteroidGrey2 = SKTexture(imageNamed: "grey2.png")
                                                                            // TEXTURE SIZES
let grey1Width = textureAsteroidGrey1.size().width
let grey1Height = textureAsteroidGrey1.size().height
let grey2Width = textureAsteroidGrey2.size().width
let grey2Height = textureAsteroidGrey2.size().height
let redWidth = textureAsteroidRed.size().width
let redHeight = textureAsteroidRed.size().height
                                                                            // ROTATION
let rotateRightAction = SKAction.rotateByAngle(5, duration: 6.0)
let repeatRightRotate = SKAction.repeatActionForever(rotateRightAction)
let rotateLeftAction = SKAction.rotateByAngle(-5, duration: 6.0)
let repeatLeftRotate = SKAction.repeatActionForever(rotateLeftAction)

let scale: CGFloat = 0.3
                                                                            // LAYERS / zPOZITIONS
struct layers {
    
    static let background: CGFloat = 0
    static let paralax: CGFloat = 1
    static let characters: CGFloat = 2
    static let projectiles: CGFloat = 3
    
}
                                                                            // BIT MASKS
struct bitMasks {
    
    // Bit Masks
   static let hero: UInt32 = 0x1 << 0
   static let enemy: UInt32 = 0x1 << 1
   static let projectileHero: UInt32 = 0x1 << 2
   static let projectileEnemy: UInt32 = 0x1 << 3
   static let noContact: UInt32 = 0x1 << 4
}

                    // Constants
var gameScene: SKScene!
let screenH = UIScreen.mainScreen().bounds.size.height
let screenW = UIScreen.mainScreen().bounds.size.width
var frameW = gameScene.frame.size.width
var frameH = gameScene.frame.size.height

let heroPosition = CGPoint(x: 100, y: frameH/2)
let enemyPosition = CGPoint(x:  frameW-100, y: frameH/2)

var spawnedHero: hero!
var spawnedEnemy: enemy!

var nodesToRemove = [SKNode]()
var objectsLayer: SKNode!

func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}

func randomIntBetweenNumbers(firstNum: Int, secondNum: Int) -> Int{
    return firstNum + Int(arc4random_uniform(UInt32(secondNum - firstNum + 1)))
}

// COLORS

let blueColor = SKColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1)
let whiteColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
let greenColor = SKColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1)
let redColor = SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1)