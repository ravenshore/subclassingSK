//
//  global.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//

import Foundation
import SpriteKit


let texturesPlayer = SKTexture(imageNamed: "player.png")
let texturesEnemy = SKTexture(imageNamed: "enemy.png")
let texturesBullet1 = SKTexture(imageNamed: "bullet1.png")
let texturesBullet2 = SKTexture(imageNamed: "bullet2.png")
let texturesBg = SKTexture(imageNamed: "bg.png")

let scale: CGFloat = 0.3

struct layers {
    
    static let background: CGFloat = 0
    static let characters: CGFloat = 2
    static let projectiles: CGFloat = 3
    
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