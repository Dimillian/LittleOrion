//
//  State.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType, Equatable {

    var universeState: UniverseState
    var playerState: PlayerState
    var uiState: UIState
}
