//
//  System.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

struct SystemId: Equatable {
    let name: String
    let location: Location

    init(name: String, location: Location) {
        self.name = name
        self.location = location
    }
}

func ==(lhs: SystemId, rhs: SystemId) -> Bool {
    return lhs.name == rhs.name &&
            lhs.location == rhs.location
}

class System: UniverseEntity {

    let id: SystemId

    private var _planets = [Planet]()

    var planets: [Planet] {
        get {
            return _planets
        }
    }
    
    var star = Star(name: "Star")

    override var description: String {
        get {
            return "System: \(id.name), Planets: \(planetsCount())"
        }
    }
    
    override var extraInfo: String? {
        get {
            var text = ""
            for planet in planets {
                text += "\(planet.name): \(planet.kind.name()), "
            }
            return text
        }
    }
    
    public init(location: Location) {
        self.id = SystemId(name: "Node x:\(location.x) y:\(location.y)", location: location)
        super.init()
        
        makePlanets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makePlanets() {
        let planetsCount = Int(arc4random_uniform(6))
        for index in 0...planetsCount {
            let star = Planet(in: self, order: index)
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
