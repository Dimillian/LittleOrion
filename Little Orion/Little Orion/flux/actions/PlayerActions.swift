//
//  PlayerActions.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

struct StartDateTimer: Action {
    var timer: Timer!

    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if store.state.playerState.isPlaying {
                store.dispatch(UpdateDateTimer(timer: timer))
            }
        })
    }
}

struct UpdateDateTimer: Action {
    let timer: Timer

    init(timer: Timer) {
        self.timer = timer
    }
}

struct PauseDateTimer: Action {

}
