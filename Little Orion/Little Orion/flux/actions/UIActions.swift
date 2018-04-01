//
//  UIActions.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift
import SpriteKit

class UIActions {
    struct ShowSelectedSystemModal: Action {
        let system: SystemEntity
    }

    struct ShowSelectionModal: Action {
        let entity: UniverseEntity
    }

    struct ShowPlanetDetail: Action {
        let planet: PlanetEntity
    }

    struct ShowUniverseScene: Action {

    }

    struct DismissModal: Action {

    }

    struct SetSelectedNode: Action {
        let node: SKNode
    }

    struct RemoveSelectedNode: Action { }
}
