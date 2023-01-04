//
//  MockStorage.swift
//  ThingsInAMapTests
//
//  Created by Ian Magallan on 02.01.23.
//

import Foundation
@testable import ThingsInAMap

final class MockStorage: Storing {
    var stubbedSetValues = [String: Double]()
    var invokedSetCount = 0

    func set(value: Double, forKey key: String) {
        stubbedSetValues[key] = value
        invokedSetCount += 1
    }

    var stubbedGetValues = [String: Double]()
    var invokedGetCount = 0

    func get(forKey key: String) -> Double? {
        invokedGetCount += 1
        return stubbedGetValues[key]
    }
}
