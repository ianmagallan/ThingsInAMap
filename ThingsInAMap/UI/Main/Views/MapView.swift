//
//  MapView.swift
//  ThingsInAMap
//
//  Created by Ian Magallan on 01.01.23.
//

import Combine
import GoogleMaps
import SwiftUI

struct MapView: UIViewRepresentable {
    @ObservedObject var origin: ObservableCoordinate
    @ObservedObject var destination: ObservableCoordinate
    @ObservedObject var selectedPointOfInterestCoordinates: ObservableCoordinate
    let pointsOfInterest: [PointOfInterest]
    let saveAction: PassthroughSubject<Void, Never>

    func makeUIView(context: Context) -> GMSMapView {
        let latCenter = (origin.latitude + destination.latitude) / 2
        let lngCenter = (origin.longitude + destination.longitude) / 2

        let camera = GMSCameraPosition.camera(
            withLatitude: latCenter,
            longitude: lngCenter,
            zoom: Constants.defaultZoom
        )
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

        mapView.delegate = context.coordinator

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context _: Context) {
        mapView.clear()

        if selectedPointOfInterestCoordinates.isSelected {
            animateToSelectedPointOfInterest(mapView)
        }

        pointsOfInterest.forEach { makePointOfInterestMarker(pointOfInterest: $0).map = mapView }
    }

    private func animateToSelectedPointOfInterest(_ mapView: GMSMapView) {
        mapView.animate(
            to: GMSCameraPosition.camera(
                withLatitude: selectedPointOfInterestCoordinates.latitude,
                longitude: selectedPointOfInterestCoordinates.longitude,
                zoom: 15
            )
        )
    }

    private func makePointOfInterestMarker(pointOfInterest: PointOfInterest) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: pointOfInterest.coordinate.latitude,
            longitude: pointOfInterest.coordinate.longitude
        )
        marker.title = "\(pointOfInterest.id)"
        marker.rotation = pointOfInterest.heading

        var markerIcon: UIImage?
        if 0 ... 180 ~= pointOfInterest.heading {
            markerIcon = "🚕".image.flippedHorizontally
            marker.rotation -= 90
        } else {
            markerIcon = "🚕".image
            marker.rotation += 90
        }

        marker.icon = markerIcon
        return marker
    }

    func makeCoordinator() -> Coordinator {
        .init(
            origin: origin,
            destination: destination,
            selectionMarkers: [
                makeSelectionMarker(
                    latitude: origin.latitude,
                    longitude: origin.longitude
                ),
                makeSelectionMarker(
                    latitude: destination.latitude,
                    longitude: destination.longitude
                ),
            ],
            saveAction: saveAction
        )
    }

    private func makeSelectionMarker(latitude: Double, longitude: Double) -> GMSMarker {
        let marker = GMSMarker()
        marker.icon = "📍".image
        marker.isDraggable = true
        marker.position = .init(
            latitude: latitude,
            longitude: longitude
        )
        return marker
    }
}

extension MapView {
    class Coordinator: NSObject, GMSMapViewDelegate {
        @ObservedObject var origin: ObservableCoordinate
        @ObservedObject var destination: ObservableCoordinate

        private var markers: [GMSMarker]
        private let saveAction: PassthroughSubject<Void, Never>

        private var circle: GMSCircle = {
            let circle = GMSCircle()
            circle.strokeWidth = 0.5
            circle.fillColor = nil
            circle.strokeColor = UIColor(named: "defaultBorderColor")

            return circle
        }()

        init(
            origin: ObservableCoordinate,
            destination: ObservableCoordinate,
            selectionMarkers: [GMSMarker],
            saveAction: PassthroughSubject<Void, Never>
        ) {
            self.origin = origin
            self.destination = destination
            markers = selectionMarkers
            self.saveAction = saveAction
        }

        func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
            markers[0].map = mapView
            markers[1].map = mapView

            drawArea(mapView: mapView, fillArea: false)
        }

        func drawArea(mapView: GMSMapView, fillArea: Bool) {
            circle.map = nil

            let latCenter = (markers[0].position.latitude + markers[1].position.latitude) / 2
            let lonCenter = (markers[0].position.longitude + markers[1].position.longitude) / 2
            let circleCenter = CLLocationCoordinate2DMake(latCenter, lonCenter)
            let radius = circleCenter.distanceInMeters(to: markers[0].position)

            if fillArea {
                circle.fillColor = UIColor(named: "selectedAreaFillColor")
                circle.strokeColor = UIColor(named: "selectedAreaBorderColor")
            } else {
                circle.fillColor = nil
                circle.strokeColor = UIColor(named: "defaultBorderColor")
            }

            circle.position = circleCenter
            circle.radius = radius
            circle.map = mapView
        }

        func mapView(_ mapView: GMSMapView, didDrag _: GMSMarker) {
            drawArea(mapView: mapView, fillArea: true)
        }

        func mapView(_ mapView: GMSMapView, didEndDragging _: GMSMarker) {
            drawArea(mapView: mapView, fillArea: false)

            origin.latitude = markers[0].position.latitude
            origin.longitude = markers[0].position.longitude
            destination.latitude = markers[1].position.latitude
            destination.longitude = markers[1].position.longitude
            saveAction.send()
        }
    }
}

extension MapView {
    private enum Constants {
        static let defaultZoom: Float = 10
    }
}
