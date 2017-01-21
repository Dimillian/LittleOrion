//
//  PlayerReducer.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/01/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import Foundation
import ReSwift

func playerReducer(state: PlayerState?, action: Action) -> PlayerState {
    var state = state ?? PlayerState()
    
    switch action {
    case let action as StartDateTimer:
        state.dateTimer = action.timer
        state.isPlaying = true
        return state
    case let action as UpdateDateTimer:
        state.dateTimer = action.timer
        state.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: state.currentDate)!
        state.isPlaying = true
        return state
    case _ as PauseDateTimer:
        state.dateTimer?.invalidate()
        state.dateTimer = nil
        state.isPlaying = false
        return state
    default:
        return state
    }
}
