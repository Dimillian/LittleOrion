//
//  UIState.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

func uiReducer(state: UIState?, action: Action) -> UIState {
    var state = state ?? UIState(selectedSystem: nil,
                                 selectedPlanet: nil,
                                 currentModal: .none,
                                 currentScene: .universe)
    switch action {
    case let action as ShowSelectedSystemModal:
        state.selectedSystem = action.system
        state.currentModal = .system
    case let action as ShowPlanetDetail:
        state.selectedPlanet = action.planet
        state.currentScene = .planet
        state.currentModal = .none
    case _ as ShowUniverseScene:
        state.selectedPlanet = nil
        state.selectedSystem = nil
        state.currentScene = .universe
        state.currentModal = .none
    case _ as DismissSystemModal:
        state.currentModal = .none
        state.selectedSystem = nil
    default:
        break
    }
    return state
}
