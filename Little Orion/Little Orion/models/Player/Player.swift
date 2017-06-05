//
//  Player.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 22/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    let name: String

    public var playerId: Int {
        get {
            return name.hashValue
        }
    }
    
    var resources = PlayerResources()

    var visitedPlanets: [PlanetId] = []
    var ownedPlanets: [PlanetId] = []

    init(name: String) {
        self.name = name
    }

}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name &&
        rhs.visitedPlanets == lhs.visitedPlanets &&
        rhs.ownedPlanets == lhs.ownedPlanets &&
        rhs.resources == lhs.resources
}
