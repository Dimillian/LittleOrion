//
//  Planet.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit
import SceneKit

//MARK: - Planet
class Planet: SystemBody {
    
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
            return ResourcesLoader.loadArrayTextResource(name: "planetsText")![Int(rawValue)]
        }
        
        func image() -> UIImage {
            return UIImage(named: ResourcesLoader.loadArrayTextResource(name: "planetsText")![Int(rawValue)])!
        }
        
    }

    let kind: Kind
    let scale: CGFloat
    var planet3D: Planet3D! = nil
    
    //resource
    //let food: Food
    //let energy: Energy
    //let mineral: Mineral
    
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
    let system: System
    
    public init(name: String, in system: System) {
        self.system = system
        kind = Kind.randomKind()
        var tmpScale = CGFloat((arc4random_uniform(600) + 400)) / 1000
        if tmpScale > 0.9 && arc4random_uniform(UniverseRules.superPlanetSpwawnProbability) == 1 {
            //1 out of X chance to generate a super planet if scale is already big.
            tmpScale = UniverseRules.superPlanetScale
        }
        scale = tmpScale
        
        super.init(name: name)
        
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
                    #imageLiteral(resourceName: "Skybox_PositiveY"),
                    #imageLiteral(resourceName: "Skybox_PositiveZ"),
                    #imageLiteral(resourceName: "Skybox_NegativeX"),
                    #imageLiteral(resourceName: "Skybox_NegativeY"),
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
 
    var planet: Planet! = nil
    
    init(planet: Planet) {
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
    
    enum Abundance: Float {
        case none = 0, low = 0.25, average = 0.5, plenty = 0.75, rare = 1
        
        func abundancyDescription() -> String {
            return "Coming soon"
        }
    }
    
    init(abundance: Abundance) {
        self.abundance = abundance
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


