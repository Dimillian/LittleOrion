//
//  PlayerMovementComponent.swift
//  LittleOrion
//
//  Created by Thomas Ricouard on 09/10/2017.
//  Copyright © 2017 Thomas Ricouard. All rights reserved.
//

import UIKit
import GameplayKit

class PlayerMovementComponent: GKComponent {

    let startDate: Date
    let startLocation: Location
    let endLocation: Location

    init(startDate: Date, from: Location, to: Location) {
        self.startDate = startDate
        self.startLocation = from
        self.endLocation = to
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddToEntity() {

    }

    override func willRemoveFromEntity() {

    }
}
