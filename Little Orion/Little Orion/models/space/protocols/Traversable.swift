//
//  Traversable.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 09/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation

// Entities which are travelable by the player need to implement that protocol.
protocol Travelable: class {

    // The numver of day that it takes to travel trough the entity which implement that function.
    var travelTimeDay: Int { get }
}
