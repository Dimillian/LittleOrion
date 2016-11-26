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
    static let nodeSize = CGSize(width: Int(UniverseSpriteComponent.size.width), height: Int(UniverseSpriteComponent.size.height))
        
    static public func component(with entity: UniverseEntity) -> UniverseSpriteComponent {
        var component: UniverseSpriteComponent
        let node: SKShapeNode
        if let system = entity as? System {
            let texture = SKTexture(imageNamed: system.star.kind.imageName())
            node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: nodeSize.width, height: nodeSize.height))
            node.name = "System node"
            node.fillTexture = texture
            node.fillColor = system.star.kind.textureFillColor()
            node.strokeColor = UIColor.red
            component = UniverseSpriteComponent(node: node)
        } else {
            node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: nodeSize.width, height: nodeSize.height))
            node.name = "Empty node"
            node.fillColor = UIColor.clear
            node.strokeColor = UIColor.white
            component = UniverseSpriteComponent(node: node)
        }
        node.lineWidth = 0.25
        return component
        
    }
    
}

extension SKShapeNode {
    
    func highlightNode(highlight: Bool) {
        self.strokeColor = highlight ? UIColor.yellow : UIColor.white
        self.lineWidth = highlight ? 1 : 0.25
        self.glowWidth = highlight ? 5 : 0
    }
}
