//
//  Star.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class Star: GKEntity {
    
    enum Kind: UInt32 {
        case sun, oceanic, toxic, continental
        
        private static let _count: Kind.RawValue = {
            var maxValue: UInt32 = 0
            while let _ = Kind(rawValue: maxValue) {
                maxValue += 1
            }
            return maxValue
        }()
        
        static func randomKind() -> Kind {
            let rand = arc4random_uniform(_count)
            return Kind(rawValue: rand)!
        }
        
        func name() -> String {
            return ResourcesLoader.loadArrayTextResource(name: "stars")![Int(self.rawValue)]
        }
    }
    
    let kind: Kind
    let name: String
    
    //A star may or may not have inhabitants.
    var inhabitants: [Pop]?
    
    public init(name: String) {
        self.name = name
        self.kind = Kind.randomKind()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
