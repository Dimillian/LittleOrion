//
//  UniverseState.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

struct UniverseState: Equatable {
    var universe: Universe?
}


func ==(lhs: UniverseState, rhs: UniverseState) -> Bool {
    return lhs.universe == rhs.universe
}




