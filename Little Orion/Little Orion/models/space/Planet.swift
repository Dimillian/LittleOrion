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
            return ResourcesLoader.loadArrayTextResource(name: "planets")![Int(rawValue)]
        }
        
        func image() -> UIImage {
            return UIImage(named: ResourcesLoader.loadArrayTextResource(name: "planets")![Int(rawValue)])!
        }
    }

    let kind: Kind
    let scale: CGFloat
    var radius: CGFloat {
        get {
            return UniverseRules.basePlanetsRadius * scale
        }
    }
    
    //A planet may or may not have inhabitants.
    var inhabitants: [Pop]?
    
    public override init(name: String) {
        kind = Kind.randomKind()
        var tmpScale = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        if tmpScale < 0.4 {
            //Can be smaller than 0.4
            tmpScale = 0.4
        } else if tmpScale > 0.9 && arc4random_uniform(UniverseRules.superPlanetSpwawnProbability) == 1{
            //1 out of 10 chance to generate a super planet if scale is already big.
            tmpScale = 1.5
        }
        scale = tmpScale
        super.init(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
