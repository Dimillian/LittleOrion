//
//  Dimension.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 25/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import Foundation

class Size: Equatable {
    var width: Int32 = 0
    var height: Int32 = 0;
    
    public init(width: Int32, height: Int32) {
        self.width = width
        self.height = height
    }
}

func ==<T: Size>(lhs: T, rhs: T) -> Bool {
    return lhs.width == rhs.width &&
        rhs.height == lhs.height
}

class Location: Equatable {
    var x: Int32 = 0
    var y: Int32 = 0
    
    public init(x: Int32, y: Int32) {
        self.x = x
        self.y = y
    }
}

func ==<T: Location>(lhs: T, rhs: T) -> Bool {
    return lhs.x == rhs.x &&
        rhs.y == lhs.y
}
