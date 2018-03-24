//
//  Discoverable.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 24/03/2018.
//  Copyright © 2018 Thomas Ricouard. All rights reserved.
//

import Foundation

// Entities which are discoverable by the player need to implement that protocol.
protocol Discoverable: class {

    var discovered: Bool { get }
    var dayToDiscover: Int { get }
}

