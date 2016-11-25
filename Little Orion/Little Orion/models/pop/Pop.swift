//
//  Pop.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 24/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class Pop: GKEntity {

    let race: Race
    
    public init(race: Race) {
        self.race = race
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
