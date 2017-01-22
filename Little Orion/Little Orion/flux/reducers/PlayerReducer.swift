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
    case let action as UpdatePlayerSpeed:
        state.currentSpeed = action.speed
    case let action as UpdateDateTimer:
        state.dateTimer = action.timer
        state.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: state.currentDate)!
        state.isPlaying = true
    case _ as UpdateDateTimerMonth:
        state.player.resources.update()
    case _ as PauseDateTimer:
        state.dateTimer?.invalidate()
        state.dateTimer = nil
        state.isPlaying = false
    case let action as PlayerVisitPlanet:
        if !state.player.visitedPlanets.contains(action.planet.id) {
            state.player.visitedPlanets.append(action.planet.id)
        }
    case let action as PlayerColonizePlanet:
        if !state.player.ownedPlanets.contains(action.planet.id) {
            state.player.ownedPlanets.append(action.planet.id)
        }
    default:
        break
    }
    return state
}
