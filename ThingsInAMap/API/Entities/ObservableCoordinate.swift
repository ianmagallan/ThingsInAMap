//
//  ObservableCoordinate.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import Foundation

final class ObservableCoordinate: ObservableObject {
    @Published var latitude: Double = .zero
    @Published var longitude: Double = .zero
    @Published var isSelected: Bool = false
}
