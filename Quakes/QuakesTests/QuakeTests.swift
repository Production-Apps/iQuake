//
//  QuakeTests.swift
//  QuakesTests
//
//  Created by Paul Solt on 10/31/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import XCTest
@testable import Quakes

class QuakeTests: XCTestCase {

    // Use throws so you don't need do/catch
    func testQuake() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let date = Date(timeIntervalSince1970: 1388620296020 / 1000.0)
        
        let quake = try decoder.decode(Quake.self, from: quakeData)
        
        //Assert(expected, actual)
        XCTAssertEqual(1.29, quake.magnitude, accuracy: 0.001)
        XCTAssertEqual("10km SSW of Idyllwild, CA", quake.place)
        XCTAssertEqual(date, quake.time)
    }

}
