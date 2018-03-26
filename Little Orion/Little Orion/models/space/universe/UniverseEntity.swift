//
//  Universe.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class UniverseRules {
    
    private static let dic = ResourcesLoader.loadDicResource(name: "universeRules")!
    
    static let systemSpawnProbability: UInt32 = dic["systemSpwawnProbability"] as! UInt32
    static let basePlanetsRadius: CGFloat = dic["basePlanetsRadius"] as! CGFloat
    static let superPlanetSpwawnProbability: UInt32 = dic["superPlanetSpwawnProbability"] as! UInt32
    static let superPlanetScale: CGFloat = dic["superPlanetScale"] as! CGFloat
    static let planetMaxSpace: Int = dic["planetMaxSpace"] as! Int
    
}

class UniverseNode: GKGridGraphNode {
    var entity: UniverseEntity!
}

struct UniverseId: Equatable, Hashable {
    let location: Location
    var name: String {
        get {
            return "Node x:\(location.x) y:\(location.y)"
        }
    }
    var hashValue: Int {
        get {
            return name.hashValue
        }
    }

    init(location: Location) {
        self.location = location
    }
}

class UniverseEntity: GKEntity, Travelable, Discoverable {

    var id: UniverseId

    var spriteNode: SKNode {
        get {
            return (component(ofType: UniverseSpriteComponent.self)?.node)!
        }
    }

    var travelTimeDay: Int {
        return 0
    }

    var discovered: Bool {
        return store.state.playerState.player.discoveredEntities.contains(id)
    }

    var dayToDiscover: Int {
        return 10
    }
    
    override var description: String {
        get {
            return "Default Universe Entity"
        }
    }
    
    var extraInfo: String? {
        get {
            return nil
        }
    }

    public init(location: Location) {
        self.id = UniverseId(location: location)
        super.init()
        addComponent(UniverseSpriteComponent.component(with: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Universe: GKEntity {
    
    let size: Size
    let grid: GKGridGraph<UniverseNode>

    enum UniverseSize: String {
        case tiny, small, standard, big
        
        func size() -> Size {
            return ResourcesLoader.loadDimensionResource(name: "universeDimensions", dimensionName: rawValue)!
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
        for node in grid.nodes! {
            if let node = node as? UniverseNode {
                let location = Location(x: node.gridPosition.x, y: node.gridPosition.y)
                if arc4random_uniform(UniverseRules.systemSpawnProbability) == 1 {
                    node.entity = SystemEntity(location: location)
                } else {
                    node.entity = EmptyEntity(location: location)
                }
            }
        }
        
        for node in grid.nodes! {
            if let node = node as? UniverseNode {
                let neighboors = node.connectedNodes
                for neighboor in neighboors {
                    if let neighboor = neighboor as? UniverseNode {
                        if let _ = neighboor.entity as? SystemEntity, let _ = node.entity as? SystemEntity {
                            let location = Location(x: node.gridPosition.x, y: node.gridPosition.y)
                            neighboor.entity = EmptyEntity(location: location)
                        }
                    }
                }
            }
        }
    }
    
    public func entityAt(location: Location) -> UniverseEntity {
        return grid.node(atGridPosition: int2(location.x, location.y))!.entity!
    }

    public func nodeAt(location: Location) -> UniverseNode? {
        return grid.node(atGridPosition: int2(location.x, location.y))
    }

    public static func grideNodePositionToMapPosition(gridNode: UniverseNode) -> CGPoint {
        let size = UniverseSpriteComponent.nodeSize
        let position = CGPoint(x: CGFloat(CGFloat(gridNode.gridPosition.x) * size.width),
                               y: CGFloat(CGFloat(gridNode.gridPosition.y) * size.height))
        return position
    }

    public static func mapNodePositionToGridPosition(mapNode: SKNode) -> Location {
        let size = UniverseSpriteComponent.nodeSize
        let gridPosition = Location(x: Int32(Int32(mapNode.position.x) / Int32(size.width)),
                                    y: Int32(Int32(mapNode.position.y) / Int32(size.height)))
        return gridPosition
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
    
        for case let node as UniverseNode in grid.nodes! {
            node.entity.components.forEach({ $0.update(deltaTime: seconds) })
        }
    }
    
}

func ==(lhs: Universe, rhs: Universe) -> Bool {
    return lhs.size == rhs.size &&
    lhs.grid == rhs.grid
}


func ==(lhs: Universe?, rhs: Universe?) -> Bool {
    return false
}
