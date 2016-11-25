//
//  Universe.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class UniverseNode: GKGridGraphNode {
    var entity: UniverseEntity!
}

class UniverseEntity: GKEntity {
        
    var spriteNode: SKSpriteNode {
        get {
            return self.component(ofType: UniverseSpriteComponent.self)!.spriteNode
        }
    }
    
    override var description: String {
        get {
            return "Unknown"
        }
    }
    
    var extraInfo: String? {
        get {
            return nil
        }
    }
    
    override init() {
        super.init()
        
        let size = CGSize(width: Int(UniverseSpriteComponent.size.width), height: Int(UniverseSpriteComponent.size.height))
        var node: SKNode
        if let _ = self as? Empty {
            node = SKSpriteNode(color: UIColor.clear, size: size)
            node.name = "Empty node"
            self.addComponent(UniverseSpriteComponent(node: node))
        } else if let system = self as? System {
            node = SKSpriteNode(texture: SKTexture(imageNamed: system.star.kind.name()), size: size)
            node.name = "System node"
            self.addComponent(UniverseSpriteComponent(node: node))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Universe: GKEntity {
    
    var systems = [System]()
    let size: Size
    let grid: GKGridGraph<UniverseNode>
    
    enum UniverseSize: String {
        case tiny, small, standard, big
        
        func size() -> Size {
            return ResourcesLoader.loadDimensionResource(name: "universe", dimensionName: self.rawValue)!
        }
    }
    
    public init(size: UniverseSize) {
        self.size = size.size()
        self.grid = GKGridGraph(fromGridStartingAt: int2(0, 0),
                                width: self.size.width,
                                height: self.size.height,
                                diagonalsAllowed: true, nodeClass: UniverseNode.self)
        super.init()
        
        generate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generate() {
        for node in self.grid.nodes! {
            if let node = node as? UniverseNode {
                if arc4random_uniform(6) == 1 {
                    node.entity = System(name: "Node x:\(node.gridPosition.x) y:\(node.gridPosition.y)")
                } else {
                    node.entity = Empty()
                }
            }
        }
        
        for node in self.grid.nodes! {
            if let node = node as? UniverseNode {
                let neighboors = node.connectedNodes
                for neighboor in neighboors {
                    if let neighboor = neighboor as? UniverseNode {
                        if let _ = neighboor.entity as? System, let _ = node.entity as? System {
                            neighboor.entity = Empty()
                        }
                    }
                }
            }
        }
    }
    
    public func entityAt(location: Location) -> UniverseEntity {
        return self.grid.node(atGridPosition: int2(location.x, location.y))!.entity!
    }
    
}
