//
//  UniverseSpriteComponent.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class UniverseSpriteComponent: GKSKNodeComponent {
    
    static let size = ResourcesLoader.loadDimensionResource(name: "universe", dimensionName: "node")!
        
    var spriteNode: SKSpriteNode {
        get {
            return self.node as! SKSpriteNode
        }
    }
}
