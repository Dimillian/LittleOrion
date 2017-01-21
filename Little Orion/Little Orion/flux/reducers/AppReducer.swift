//
//  AppReducer.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {

    func handleAction(action: Action, state: State?) -> State {
        return State(
            universeState: universeReducer(state: state?.universeState, action: action),
            playerState: playerReducer(state: state?.playerState, action: action),
            uiState: uiReducer(state: state?.uiState, action: action)
        )
    }
}
