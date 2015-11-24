//
//  protocols.swift
//  subclassingSK
//
//  Created by Razvigor Andreev on 11/17/15.
//  Copyright © 2015 Razvigor Andreev. All rights reserved.
//

import Foundation
import SpriteKit

protocol pWeapon {
    
    func shoot(target: pTargetable)
    
}

protocol pTargetable {
    
    var health: Int { get set }
    func takeDamage(damage: Int)
    
    
}

class Gun: pWeapon {
    func shoot(target: pTargetable) {
        target.takeDamage(1)
    }
}
