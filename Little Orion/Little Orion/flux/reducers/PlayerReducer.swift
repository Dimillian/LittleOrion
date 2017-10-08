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
    case let action as PlayerActions.StartTimer:
        state.dateTimer = action.timer
        state.isPlaying = true
    case let action as PlayerActions.UpdateSpeed:
        state.currentSpeed = action.speed
    case let action as PlayerActions.UpdateTimer:
        state.dateTimer = action.timer
        state.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: state.currentDate)!
        state.isPlaying = true
    case _ as PlayerActions.UpdateTimerMonth:
        state.player.resources.update()
    case _ as PlayerActions.PauseTimer:
        state.dateTimer?.invalidate()
        state.dateTimer = nil
        state.isPlaying = false
    case let action as PlayerActions.VisitPlanet:
        if !state.player.visitedPlanets.contains(action.planet.id) {
            state.player.visitedPlanets.append(action.planet.id)
        }
    case let action as PlayerActions.ColonizePlanet:
        if !state.player.ownedPlanets.contains(action.planet.id) {
            state.player.ownedPlanets.append(action.planet.id)
        }
    case let action as PlayerActions.UpdatePosition:
        state.player.position = action.position
    default:
        break
    }
    return state
}
