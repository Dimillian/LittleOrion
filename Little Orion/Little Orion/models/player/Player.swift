//
//  Player.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 22/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import GameplayKit

class Player: GKEntity, GKGameModelPlayer {
    let name: String

    public var playerId: Int {
        get {
            return name.hashValue
        }
    }
    
    var resources = PlayerResources()

    var discoveringEntities: [UniverseId: Int] = [:]
    var discoveredEntities: Set<UniverseId> = []
    var discoveringPlanets: [PlanetId: Int] = [:]
    var discoveredPlanets: Set<PlanetId> = []

    var spriteNode: SKNode {
        get {
            return component(ofType: PlayerSpriteComponent.self)!.node
        }
    }

    var position = CGPoint.zero {
        didSet {
            spriteNode.position = position
        }
    }

    var isInMovement: Bool {
        return component(ofType: PlayerMovementComponent.self) != nil
    }

    init(name: String) {
        self.name = name
        super.init()

        addComponent(PlayerSpriteComponent())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
