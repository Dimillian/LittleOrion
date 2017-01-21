//
//  UIState.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

struct UIState {

    var selectedSystem: System?
    var selectedPlanet: Planet?
    var currentModal: Modal
    var currentScene: Scene
}

enum Modal {
    case none
    case system

}

enum Scene {
    case universe
    case planet
}
