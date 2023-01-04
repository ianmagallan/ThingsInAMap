//
//  Storage.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import Foundation

protocol Storing {
    func set(value: Double, forKey key: String)
    func get(forKey key: String) -> Double?
}

final class Storage: Storing {
    private let userDefaults = UserDefaults.standard

    func set(value: Double, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func get(forKey key: String) -> Double? {
        userDefaults.value(forKey: key) as? Double
    }
}

extension Storage {
    enum Key: String {
        case p1Lat, p1Lon, p2Lat, p2Lon
    }
}
