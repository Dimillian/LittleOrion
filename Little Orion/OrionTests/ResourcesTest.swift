//
//  ResourcesTest.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 24/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import XCTest
@testable import Little_Orion


class ResourcesTest: XCTestCase {
    
    let test1result = "test 1 result"
    let test2result = "test 2 result"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testResourceLoader() {
        let plist = ResourcesLoader.loadTextResource(name: "tests")
        if let plist = plist {
            XCTAssertEqual(plist["test1"], test1result)
            XCTAssertEqual(plist["test2"], test2result)
        } else {
            XCTFail("plist is nil")
        }
    }
    
}
