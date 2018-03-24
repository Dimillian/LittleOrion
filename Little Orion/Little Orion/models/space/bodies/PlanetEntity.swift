//
//  Planet.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit
import SceneKit

struct PlanetId: Equatable, Hashable {
    let systemId: UniverseId
    let index: Int
    
    var hashValue: Int {
        get {
            return systemId.hashValue * index.hashValue
        }
    }

    init(systemId: UniverseId, index: Int) {
        self.systemId = systemId
        self.index = index
    }
}

//MARK: - Planet
class PlanetEntity: SystemBody, Discoverable {

    static let planetRessourceModifier = ResourcesLoader.loadPlanetResource(name: "planetResourcesModifier")!
    static let planetNames = ResourcesLoader.loadArrayTextResource(name: "planetsText")!

    enum Kind: UInt32 {
        case desert, oceanic, toxic, continental, frozen, volcanic
        
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
            return planetNames[Int(rawValue)]
        }
        
        func image() -> UIImage {
            return UIImage(named: ResourcesLoader.loadArrayTextResource(name: "planetsText")![Int(rawValue)])!
        }

        func ressources() -> [String: Int] {
            return planetRessourceModifier[name()]!
        }
        
    }

    var discovered: Bool {
        return store.state.playerState.player.discoveredPlanets.contains(id)
    }

    var dayToDiscover: Int {
        return 200
    }

    let id: PlanetId
    let kind: Kind
    let scale: CGFloat
    var planet3D: Planet3D! = nil
    
    //resource
    let food: Food
    let energy: Energy
    let mineral: Mineral
    let reseach: Research

    var resourceScore: Int {
        get {
            return food.abundance.rawValue +
                    energy.abundance.rawValue +
                    mineral.abundance.rawValue +
                    reseach.abundance.rawValue
        }
    }

    //The radius, in KM of the planet.
    var radius: CGFloat {
        get {
            return UniverseRules.basePlanetsRadius * scale
        }
    }
    
    //How many space are buildable on this planet.
    var space: Int {
        get {
            let divider = (UniverseRules.basePlanetsRadius * UniverseRules.superPlanetScale) / CGFloat(UniverseRules.planetMaxSpace)
            return Int(radius / divider)
        }
    }
    
    
    //A planet may or may not have inhabitants.
    private var inhabitants: [Pop]?
    
    //The parent system of the planet.
    let system: SystemEntity
    
    public init(in system: SystemEntity, order: Int) {
        id = PlanetId(systemId: system.id, index: order)
        self.system = system
        kind = Kind.randomKind()
        var tmpScale = CGFloat((arc4random_uniform(600) + 400)) / 1000
        if tmpScale > 0.9 && arc4random_uniform(UniverseRules.superPlanetSpwawnProbability) == 1 {
            //1 out of X chance to generate a super planet if scale is already big.
            tmpScale = UniverseRules.superPlanetScale
        }
        scale = tmpScale
        food = Food(abundance: PlanetResource.Abundance(rawValue: kind.ressources()["Food"]!)!)
        mineral = Mineral(abundance: PlanetResource.Abundance(rawValue: kind.ressources()["Mineral"]!)!)
        energy = Energy(abundance: PlanetResource.Abundance(rawValue: kind.ressources()["Energy"]!)!)
        reseach = Research(abundance: PlanetResource.Abundance(rawValue: kind.ressources()["Research"]!)!)
        
        super.init(name: "Planet \(order)")
        
        planet3D = Planet3D(planet: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func inhabitantsCount() -> Int {
        if let inhabitants = inhabitants {
            return inhabitants.count
        }
        return 0
    }
    
    func addInhabitants(pop: Pop) {
        if inhabitants == nil {
            inhabitants = [Pop]()
        }
        inhabitants?.append(pop)
    }
}

//MARK: - 3D
class Planet3D {
    
    var skybox: [UIImage] {
        get {
            return [#imageLiteral(resourceName: "Skybox_PositiveX"),
                    #imageLiteral(resourceName: "Skybox_NegativeX"),
                    #imageLiteral(resourceName: "Skybox_PositiveY"),
                    #imageLiteral(resourceName: "Skybox_NegativeY"),
                    #imageLiteral(resourceName: "Skybox_PositiveZ"),
                    #imageLiteral(resourceName: "Skybox_NegativeZ")]
        }
    }
    
    var sphere: SCNSphere {
        get {
            let sphere = SCNSphere(radius: 5.0)
            let textureName = planet.kind.name() + "Texture"
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: textureName)
            material.specular.contents = planet.system.star.kind.textureFillColor()
            material.shininess = 0.8
            sphere.materials = [material]
            return sphere
        }
    }
    
    var light: SCNNode {
        get {
            let omniLightNode = SCNNode()
            omniLightNode.light = SCNLight()
            omniLightNode.light?.color = planet.system.star.kind.textureFillColor()
            omniLightNode.light?.type = .omni
            omniLightNode.position = SCNVector3Make(0, 40, 40)
            return omniLightNode
        }
    }
 
    var planet: PlanetEntity! = nil
    
    init(planet: PlanetEntity) {
        self.planet = planet
    }
}

//MARK: - Resources
class PlanetResource {

    var name: String {
        get {
            return ""
        }
    }
    
    var description: String {
        get {
            return ""
        }
    }
    
    let abundance: Abundance
    
    enum Abundance: Int {
        case none, low, average, plenty, enormous
        
        func abundancyDescription() -> String {
            return "Coming soon"
        }
    }
    
    init(abundance: Abundance) {
        let randomness = arc4random_uniform(3)
        if randomness == 1 && abundance.rawValue > 0 {
            self.abundance = Abundance(rawValue: abundance.rawValue - 1)!
        }
        else if randomness == 2 && abundance.rawValue < 4 {
            self.abundance = Abundance(rawValue: abundance.rawValue + 1)!
        }
        else {
            self.abundance = abundance
        }
    }
}

class Food: PlanetResource {
    
    override var name: String {
        get {
            return "Food"
        }
    }
    
    override var description: String {
        get {
            return "The foods available on the planet"
        }
    }
}


class Mineral: PlanetResource {
    
    override var name: String {
        get {
            return "Mineral"
        }
    }
    
    override var description: String {
        get {
            return "The minerals available on the planet"
        }
    }
}

class Energy: PlanetResource {
    
    override var name: String {
        get {
            return "Energy"
        }
    }
    
    override var description: String {
        get {
            return "The energy available on the planet"
        }
    }
}

class Research: PlanetResource {

    override var name: String {
        get {
            return "Science"
        }
    }

    override var description: String {
        get {
            return "The research (for science) available on the planet"
        }
    }
}


