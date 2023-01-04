//
//  MainView.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 30.12.22.
//

import Combine
import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    @ObservedObject var selectedPointOfInterestCoordinates = ObservableCoordinate()

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView().progressViewStyle(.circular)
            } else {
                MapView(
                    origin: viewModel.selectedOrigin,
                    destination: viewModel.selectedDestination,
                    selectedPointOfInterestCoordinates: selectedPointOfInterestCoordinates,
                    pointsOfInterest: viewModel.pointsOfInterest,
                    saveAction: viewModel.saveAction
                )
            }
        }
        .overlay(alignment: .bottom) {
            List(viewModel.pointsOfInterest) { pointOfInterest in
                Button(action: {
                    selectedPointOfInterestCoordinates.latitude = pointOfInterest.coordinate.latitude
                    selectedPointOfInterestCoordinates.longitude = pointOfInterest.coordinate.longitude
                    selectedPointOfInterestCoordinates.isSelected = true
                }) {
                    PointOfInterestRow(pointOfInterest: pointOfInterest)
                }
            }
            .frame(height: 200)
            .listStyle(.plain)
        }
        .onAppear {
            viewModel.fetchPointsOfInterest()
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
