//
//  ChattingTests.swift
//  ChattingTests
//
//  Created by Haamed Sultani on 2018-09-21.
//  Copyright © 2018 Sultani. All rights reserved.
//

import XCTest

class ChattingTests: XCTestCase {

    func testHelloWorld() {
        var helloWorld: String?
        
        XCTAssertNil(helloWorld) // Check if variable is nil
        
        helloWorld = "Hello world"
        XCTAssertEqual(helloWorld, "Hello world") // Check if assignment worked
    }
    
    

}
