//
//  PlayerSpriteComponent.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 08/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class PlayerSpriteComponent: GKSKNodeComponent {

    override init() {
        let texture = SKTexture(image: #imageLiteral(resourceName: "Spaceship"))
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: UniverseSpriteComponent.nodeSize.width,
                                            height: UniverseSpriteComponent.nodeSize.height))
        node.name = "System node"
        node.fillTexture = texture
        node.fillColor = .white
        super.init(node: node)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
