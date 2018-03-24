//
//  PlayerActions.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

class PlayerActions {
    struct Initialize: Action {}

    struct StartTimer: Action {
        var timer: Timer!
        var currentDate: Date!

        init() {
            self.currentDate = store.state.playerState.currentDate
            let speed = store.state.playerState.currentSpeed
            var copy = self
            self.timer = Timer.scheduledTimer(withTimeInterval: speed.rawValue, repeats: true, block: { (timer) in
                if store.state.playerState.isPlaying {
                    store.dispatch(UpdateTimer(timer: timer))
                    copy.currentDate = store.state.playerState.currentDate
                    if Calendar.current.isDate(copy.currentDate, equalTo: copy.endOfMonth(), toGranularity: .day) {
                        store.dispatch(UpdateTimerMonth(timer: timer))
                    }
                }
            })
        }

        func startOfMonth() -> Date {
            return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month],
                                                                               from: Calendar.current.startOfDay(for:
                                                                                currentDate)))!
        }

        func endOfMonth() -> Date {
            return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
        }
    }

    struct UpdateSpeed: Action {
        let speed: PlayerSpeed

        init(speed: PlayerSpeed) {
            self.speed = speed

            // Hacky workaround to wait for the init to be done so the state is up to date when restarting the timer.
            // Will do better later.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                store.dispatch(PauseTimer())
                store.dispatch(StartTimer())
            }
        }
    }

    struct UpdateTimer: Action {
        let timer: Timer

        init(timer: Timer) {
            self.timer = timer
        }
    }

    struct UpdateTimerMonth: Action {
        let timer: Timer

        init(timer: Timer) {
            self.timer = timer
        }
    }

    struct MoveToPosition: Action {
        let movement: PlayerMovementComponent
    }
    
    struct UpdatePosition: Action {
        let position: CGPoint
    }

    struct StopMovement: Action {}

    struct PauseTimer: Action {

    }
}
