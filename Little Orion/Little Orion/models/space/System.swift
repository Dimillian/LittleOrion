//
//  System.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class System: UniverseEntity {
    
    private var _planets = [Planet]()
    var planets: [Planet] {
        get {
            return _planets
        }
    }
    
    var star = Star(name: "Star")
    
    let name: String
    
    override var description: String {
        get {
            return"System: \(self.name), Planets: \(self.planetsCount())"
        }
    }
    
    override var extraInfo: String? {
        get {
            var text = ""
            for planet in self.planets {
                text += "\(planet.name): \(planet.kind.name()), "
            }
            return text
        }
    }
    
    public init(name: String) {
        self.name = name
        super.init()
        
        makePlanets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makePlanets() {
        let planetsCount = Int(arc4random_uniform(6))
        for index in 0...planetsCount {
            let star = Planet(name: "Planet \(index)")
            _planets.append(star)
        }
    }
    
    func planet(at: Int) -> Planet {
        return _planets[at]
    }
    
    func planetsCount() -> Int {
        return _planets.count
    }
    
}
