//
//  Race.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class Race: GKEntity {
    
    enum Kind: String {
        case human, lizard, plantoid
        
        func description() -> String {
            return ResourcesLoader.loadTextResource(name: "raceText")![rawValue]!
        }
    }
    
    enum Force: String {
        case weak, average, strong
        
        func modifier() -> Float {
            return ResourcesLoader.loadModifierResource(name: "raceForceModifier")![rawValue]!
        }
    }
    
    let name: String
    let kind: Kind
    let force: Force
    
    init(name: String, kind: Kind, force: Force) {
        self.kind = kind
        self.force = force
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
