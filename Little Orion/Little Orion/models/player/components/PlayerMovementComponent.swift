//
//  PlayerMovementComponent.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 09/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import UIKit
import GameplayKit
import ReSwift

class PlayerMovementComponent: GKComponent {

    let startDate: Date
    let startLocation: Location
    let endLocation: Location

    var travelPath: [GKGraphNode] = []
    var previousDate: Date

    init(startDate: Date, from: Location, to: Location) {
        self.startDate = startDate
        self.startLocation = from
        self.endLocation = to
        self.previousDate = startDate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddToEntity() {
        super.didAddToEntity()

        if let universe = store.state.universeState.universe {
            if let startNode = universe.nodeAt(location: startLocation),
                let endNode = universe.nodeAt(location: endLocation) {
                for node in startNode.findPath(to: endNode) {
                    if let node = node as? UniverseNode {
                        for _ in 0..<node.entity.travelTimeDay {
                            travelPath.append(node)
                        }
                    }
                }
            }
        }

        store.subscribe(self) {
            $0.select{ $0.playerState }.skipRepeats()
        }
    }

    override func willRemoveFromEntity() {
        super.willRemoveFromEntity()

        store.unsubscribe(self)
    }
}

extension PlayerMovementComponent: StoreSubscriber {
    func newState(state: PlayerState) {
        DispatchQueue.main.async {
            if state.currentDate != self.previousDate {
                let numberOfDay = store.state.playerState.currentDate.numberOfDaysSince(date: self.startDate)
                if numberOfDay < self.travelPath.count, let node = self.travelPath[numberOfDay] as? UniverseNode {
                    store.dispatch(PlayerActions.UpdatePosition(position: Universe.grideNodePositionToMapPosition(gridNode: node)))
                } else {
                    self.entity?.removeComponent(ofType: PlayerMovementComponent.self)
                }
            }
            self.previousDate = state.currentDate
        }
    }
}
