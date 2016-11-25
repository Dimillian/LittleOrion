//
//  Star.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class Star: SystemBody {
    
    enum Kind: UInt32 {
        case dwarf, supernova
        
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
        
        func image() -> UIImage {
            return UIImage(named: ResourcesLoader.loadArrayTextResource(name: "stars")![Int(self.rawValue)])!
        }
    }
    
    let kind: Kind
        
    public override init(name: String) {
        self.kind = Kind.randomKind()
        super.init(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
