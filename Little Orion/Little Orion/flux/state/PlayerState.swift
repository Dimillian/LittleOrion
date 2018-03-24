//
//  PlayerState.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

enum PlayerSpeed: TimeInterval {
    case slow = 1.5
    case normal = 1.0
    case fast = 0.5
    case faster = 0.2

    func nextValue() -> PlayerSpeed {
        switch self {
        case .slow:
            return .normal
        case .normal:
            return .fast
        case .fast:
            return .faster
        case .faster:
            return .slow
        }
    }

    func displayValue() -> String {
        switch self {
        case .slow:
            return "0.5"
        case .normal:
            return "1.0"
        case .fast:
            return "1.5"
        case .faster:
            return "2.0"
        }
    }
}

struct PlayerState: Equatable {
    var player = Player(name: "Player 1")
    var currentDate = Date()
    var dateTimer: Timer?
    var currentSpeed = PlayerSpeed.normal
    var isPlaying = false
}
