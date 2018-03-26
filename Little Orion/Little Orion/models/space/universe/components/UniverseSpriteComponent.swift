//
//  UniverseSpriteComponent.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class UniverseSpriteComponent: GKSKNodeComponent {
    
    static let size = ResourcesLoader.loadDimensionResource(name: "universeDimensions", dimensionName: "node")!
    static let nodeSize = CGSize(width: Int(UniverseSpriteComponent.size.width), height: Int(UniverseSpriteComponent.size.height))

    static public func component(with entity: UniverseEntity) -> UniverseSpriteComponent {
        var component: UniverseSpriteComponent
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: nodeSize.width, height: nodeSize.height))
        node.lineWidth = 0.50
        node.strokeColor = UIColor.init(white: 1.0, alpha: 0.5)
        node.fillColor = node.undiscovedColor
        if let _ = entity as? SystemEntity {
            node.name = "System node"
        } else {
            node.name = "Empty node"
        }
        component = UniverseSpriteComponent(node: node)
        return component
        
    }

    override func update(deltaTime seconds: TimeInterval) {
        if let universeEntity = entity as? UniverseEntity, let node = node as? SKShapeNode {
            let discovered = universeEntity.discovered
            if let systemEntity = universeEntity as? SystemEntity, discovered {
                if node.fillTexture == nil {
                    let texture = SKTexture(imageNamed: systemEntity.star.kind.imageName())
                    node.fillTexture = texture
                }
                node.fillColor = systemEntity.star.kind.textureFillColor()
                node.strokeColor = .red
                node.glowWidth = 3
            } else {
                node.fillColor = discovered ? .clear : node.undiscovedColor
                node.glowWidth = discovered ? 2 : 0
                node.strokeColor = UIColor.init(white: 1.0, alpha: 0.5)
            }

            if let dayProgress = store.state.playerState.player.discoveringEntities[universeEntity.id] {
                let progress = Float(dayProgress) / Float(universeEntity.dayToDiscover)
                node.strokeColor = UIColor.green.withAlphaComponent(CGFloat(progress))
            }

            if node == store.state.uiState.selectedNode {
                node.glowWidth = 5
            }

            if let movement = store.state.playerState.player.component(ofType: PlayerMovementComponent.self) {
                // TODO: Highlight node for player movement
            }
        }
    }
    
}

extension SKShapeNode {

    var undiscovedColor: UIColor {
        return UIColor.gray.withAlphaComponent(0.3)
    }
}
