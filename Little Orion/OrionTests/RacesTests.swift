//
//  RacesTests.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 24/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import XCTest
@testable import LittleOrion

class RacesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testsDescription() {
        let race = Race(name: "race1", kind: .human, force: .weak)
        let race2 = Race(name: "race2", kind: .plantoid, force: .weak)
        let race3 = Race(name: "race3", kind: .lizard, force: .weak)
        
        XCTAssertNotNil(race.kind.description())
        XCTAssertNotNil(race2.kind.description())
        XCTAssertNotNil(race3.kind.description())
        
        XCTAssertNotNil(race.force.modifier())
        XCTAssertNotNil(race2.force.modifier())
        XCTAssertNotNil(race3.force.modifier())
        
    }
    
}
