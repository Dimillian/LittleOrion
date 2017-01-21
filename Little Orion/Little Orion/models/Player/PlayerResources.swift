//
//  PlayerResource.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

enum PlayerResourceType: String {
    case energy, minerals, science
}

class PlayerResource {

    let type: PlayerResourceType
    var value = 0
    var income: Int {
        get {
            //TODO: Random for now, will be calculated from player inhabited planets
            return Int(arc4random_uniform(10))
        }
    }

    init(type: PlayerResourceType) {
        self.type = type
    }


    func update() {
        value += income
    }
}

class PlayerResources {
    var energy = PlayerResource(type: .energy)
    var minerals = PlayerResource(type: .minerals)
    var science = PlayerResource(type: .science)

    func update() {
        self.energy.update()
        self.minerals.update()
        self.science.update()
    }
}
