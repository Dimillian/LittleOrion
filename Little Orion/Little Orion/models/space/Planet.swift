//
//  Planet.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class Planet: SystemBody {

    enum Kind: UInt32 {
        case desert, oceanic, toxic, continental
        
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
            return ResourcesLoader.loadArrayTextResource(name: "planets")![Int(self.rawValue)]
        }
        
        func image() -> UIImage {
            return UIImage(named: ResourcesLoader.loadArrayTextResource(name: "planets")![Int(self.rawValue)])!
        }
    }

    let kind: Kind
    
    //A planet may or may not have inhabitants.
    var inhabitants: [Pop]?
    
    public override init(name: String) {
        self.kind = Kind.randomKind()
        super.init(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
