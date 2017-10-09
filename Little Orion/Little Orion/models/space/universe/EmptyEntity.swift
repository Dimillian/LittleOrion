//
//  Empty.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class EmptyEntity: UniverseEntity {
    
    override var travelTimeDay: Int {
        return 5
    }
    
    override var description: String {
        get {
            return "Empty part of the universe"
        }
    }
}
