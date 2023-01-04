//
//  MainViewModel.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine
import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    // MARK: - Properties -

    @Published var pointsOfInterest = [PointOfInterest]()
    @Published var isLoading = true
    @ObservedObject var selectedOrigin = ObservableCoordinate()
    @ObservedObject var selectedDestination = ObservableCoordinate()
    let saveAction = PassthroughSubject<Void, Never>()

    private var cancellableBag = Set<AnyCancellable>()
    private let pointOfInterestProvider: PointOfInterestProviding
    private let storage: Storing

    // MARK: - Init -

    init(
        pointOfInterestProvider: PointOfInterestProviding = PointOfInterestProvider(),
        storage: Storing = Storage()
    ) {
        self.pointOfInterestProvider = pointOfInterestProvider
        self.storage = storage

        updateCoordinatesValuesFromStorage()
        observeCoordinateEvents()
    }

    private func observeCoordinateEvents() {
        saveAction.sink { [unowned self] in fetchPointsOfInterest() }
            .store(in: &cancellableBag)

        selectedOrigin.$latitude.sink { [unowned self] value in
            updateCoordinateValueInStorage(value: value, forKey: .p1Lat)
        }
        .store(in: &cancellableBag)

        selectedOrigin.$longitude.sink { [unowned self] value in
            updateCoordinateValueInStorage(value: value, forKey: .p1Lon)
        }
        .store(in: &cancellableBag)

        selectedDestination.$latitude.sink { [unowned self] value in
            updateCoordinateValueInStorage(value: value, forKey: .p2Lat)
        }
        .store(in: &cancellableBag)

        selectedDestination.$longitude.sink { [unowned self] value in
            updateCoordinateValueInStorage(value: value, forKey: .p2Lon)
        }
        .store(in: &cancellableBag)
    }

    // MARK: - Storage -

    private func updateCoordinatesValuesFromStorage() {
        selectedOrigin.latitude = storage.get(forKey: Storage.Key.p1Lat.rawValue) ?? 53.694865
        selectedOrigin.longitude = storage.get(forKey: Storage.Key.p1Lon.rawValue) ?? 9.757589
        selectedDestination.latitude = storage.get(forKey: Storage.Key.p2Lat.rawValue) ?? 53.394655
        selectedDestination.longitude = storage.get(forKey: Storage.Key.p2Lon.rawValue) ?? 10.099891
    }

    private func updateCoordinateValueInStorage(value: Double, forKey: Storage.Key) {
        storage.set(value: value, forKey: forKey.rawValue)
    }

    // MARK: - Requests -

    func fetchPointsOfInterest() {
        updateCoordinatesValuesFromStorage()
        pointOfInterestProvider.fetchPointsOfInterest(
            p1Lat: selectedOrigin.latitude,
            p1Lon: selectedOrigin.longitude,
            p2Lat: selectedDestination.latitude,
            p2Lon: selectedDestination.longitude
        )
        .sink { [weak self] result in
            self?.isLoading = false
            guard case let .failure(error) = result else {
                return
            }
            switch error {
            case .network:
                print("Do whatever: Network error")
            case .parsing:
                print("Do whatever: Parsing error")
            case .unknown:
                print("Do whatever: Unknown error")
            }
        } receiveValue: { [weak self] pointsOfInterest in
            self?.pointsOfInterest = pointsOfInterest
        }.store(in: &cancellableBag)
    }
}
