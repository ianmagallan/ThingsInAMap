//
//  PointOfInterestRow.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import SwiftUI

struct PointOfInterestRow: View {
    @ObservedObject var viewModel = PointOfInterestRowViewModel()
    let pointOfInterest: PointOfInterest

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Thing: \(pointOfInterest.id)")
                Circle().frame(width: 10).foregroundColor(pointOfInterest.state == .active ? .green : .red)
            }
            Text(viewModel.streetLocation)
                .redacted(reason: viewModel.didLoadLocation ? [] : .placeholder)
        }.task {
            await viewModel.fetchStreetLocation(
                latitude: pointOfInterest.coordinate.latitude,
                longitude: pointOfInterest.coordinate.longitude
            )
        }
    }
}

struct PointOfInterestRow_Previews: PreviewProvider {
    private static let coordinate = PointOfInterest.Coordinate(
        latitude: 53.5720097,
        longitude: 10.0642515
    )

    private static let pointOfInterest = PointOfInterest(
        id: 1,
        coordinate: coordinate,
        state: .active,
        heading: 100
    )

    static var previews: some View {
        PointOfInterestRow(pointOfInterest: pointOfInterest)
    }
}
