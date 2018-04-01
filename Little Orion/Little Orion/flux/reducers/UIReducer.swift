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
    var state = state ?? UIState(selectedEntity: nil,
                                 selectedSystem: nil,
                                 selectedPlanet: nil,
                                 currentModal: .none,
                                 currentScene: .universe,
                                 selectedNode: nil)
    switch action {
    case let action as UIActions.ShowSelectedSystemModal:
        state.selectedSystem = action.system
        state.currentModal = .system

    case let action as UIActions.ShowSelectionModal:
        state.selectedEntity = action.entity
        state.currentModal = .entity

    case let action as UIActions.ShowPlanetDetail:
        state.selectedPlanet = action.planet
        state.currentScene = .planet
        state.currentModal = .none

    case _ as UIActions.ShowUniverseScene:
        state.selectedPlanet = nil
        state.selectedSystem = nil
        state.currentScene = .universe
        state.currentModal = .none

    case _ as UIActions.DismissModal:
        state.currentModal = .none
        state.selectedSystem = nil
        state.selectedEntity = nil

    case let action as UIActions.SetSelectedNode:
        state.selectedNode = action.node

    case _ as UIActions.RemoveSelectedNode:
        state.selectedNode = nil

    default:
        break
    }
    return state
}
