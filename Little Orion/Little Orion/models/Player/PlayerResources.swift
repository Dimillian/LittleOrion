//
//  PlayerResource.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

class PlayerResource {
    var value = 0
    var income = 0

    func update() {
        value += income
    }
}

class PlayerResources {
    var energy = PlayerResource()
    var minerals = PlayerResource()
    var science = PlayerResource()

    func update() {
        self.energy.update()
        self.minerals.update()
        self.science.update()
    }
}
