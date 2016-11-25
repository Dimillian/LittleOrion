//
//  Nation.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 24/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import GameplayKit

class Nation: GKEntity {
    
    private var pops: [Pop]
    
    //A nation must be created with at least one pop in it.
    init(pops: [Pop]) {
        self.pops = pops
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPop(pop: Pop) {
        pops.append(pop)
    }
    
    public func removePop(pop: Pop) {
        if let index = pops.index(of: pop) {
            pops.remove(at: index)   
        }
    }

}
