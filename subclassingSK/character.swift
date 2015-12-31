//
//  character.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//

import UIKit
import SpriteKit

class character: SKNode {
    

    var scorePoints = 1
    var size = CGSize(width: 50, height: 50)
   
    
    override init() {
        super.init()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    func die() {
        gameOver = true
        self.removeFromParent()
    }
  
}
