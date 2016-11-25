//
//  System.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class System: UniverseEntity {
    
    private var _stars = [Star]()
    var stars: [Star] {
        get {
            return _stars
        }
    }
    
    let name: String
    
    override var description: String {
        get {
            return"System: \(self.name), Stars: \(self.starsCount())"
        }
    }
    
    override var extraInfo: String? {
        get {
            var text = ""
            for star in self.stars {
                text += "\(star.name): \(star.kind.name()), "
            }
            return text
        }
    }
    
    public init(name: String) {
        self.name = name
        super.init()
        
        makeStars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeStars() {
        let startCount = Int(arc4random_uniform(6))
        for index in 0...startCount {
            let star = Star(name: "Star \(index)")
            _stars.append(star)
        }
    }
    
    func star(at: Int) -> Star {
        return _stars[at]
    }
    
    func starsCount() -> Int {
        return _stars.count
    }
    
}
