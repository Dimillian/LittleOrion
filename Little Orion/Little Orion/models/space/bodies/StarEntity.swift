//
//  Star.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class StarEntity: SystemBody {
    
    enum Kind: UInt32 {
        case nova, supernova, dwarf
        
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
            return ResourcesLoader.loadArrayTextResource(name: "starsText")![Int(rawValue)]
        }
        
        func imageName() -> String {
            return "Star"
        }
        func image() -> UIImage {
            return #imageLiteral(resourceName: "Star")
        }
        
        func textureFillColor() -> UIColor {
            switch self {
            case .nova:
                return UIColor(red: 5/255, green: 22/255, blue: 177/255, alpha: 1.0)
            case .dwarf:
                return UIColor(red: 248/255, green: 187/255, blue: 66/255, alpha: 1.0)
            case .supernova:
                return UIColor(red: 199/255, green: 20/255, blue: 21/255, alpha: 1.0)
            }
        }
    }
    
    let kind: Kind
        
    public override init(name: String) {
        kind = Kind.randomKind()
        super.init(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
