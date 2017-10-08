//
//  UniverseReducer.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

func universeReducer(state: UniverseState?, action: Action) -> UniverseState {
    var state = state ?? UniverseState()
    switch action {
    case let action as UniverseActions.CreateUnivserse:
        state.universe = Universe(size: action.size)
    default:
        break
    }
    return state
}
