//
//  AppReducer.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

func AppReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        universeState: universeReducer(state: state?.universeState, action: action),
        playerState: playerReducer(state: state?.playerState, action: action),
        uiState: uiReducer(state: state?.uiState, action: action)
    )
}
