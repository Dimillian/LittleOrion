//
//  System.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

struct SystemId: Equatable, Hashable {
    let location: Location
    var name: String {
        get {
            return "Node x:\(location.x) y:\(location.y)"
        }
    }
    var hashValue: Int {
        get {
            return name.hashValue
        }
    }

    init(location: Location) {
        self.location = location
    }
}

class SystemEntity: UniverseEntity {

    let id: SystemId

    private var _planets = [PlanetEntity]()

    var planets: [PlanetEntity] {
        get {
            return _planets
        }
    }

    override var travelTimeDay: Int {
        return 5
    }
    
    var star = StarEntity(name: "Star")

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
        self.id = SystemId(location: location)
        super.init()
        
        makePlanets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makePlanets() {
        let planetsCount = Int(arc4random_uniform(6))
        for index in 0...planetsCount {
            let star = PlanetEntity(in: self, order: index)
            _planets.append(star)
        }
    }
    
    func planet(at: Int) -> PlanetEntity {
        return _planets[at]
    }
    
    func planetsCount() -> Int {
        return _planets.count
    }
    
}
