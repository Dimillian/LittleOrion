//
//  Player.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 22/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation

class Player {
    let name: String

    var resources = PlayerResources()

    var visitedPlanets: [PlanetId] = []
    var ownedPlanets: [PlanetId] = []

    init(name: String) {
        self.name = name
    }
}
