//
//  PlayerState.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

struct PlayerState {
    var username: String?
    var currentDate = Date()
    var dateTimer: Timer?
    var isPlaying = false
}
