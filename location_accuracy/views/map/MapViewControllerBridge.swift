//
//  MapViewControllerBridge.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import UIKit
import SwiftUI
import GoogleMaps
import CoreLocation

struct MapViewControllerBridge: UIViewControllerRepresentable {
    
    @Binding var myLocation: CLLocationCoordinate2D?
    @Binding var pins: [CLLocationCoordinate2D]
    var didChangeCameraPosition: (GMSCameraPosition) -> ()
    
    var myLocationMoveOneTime: (Bool) -> ()
    
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: Context) -> MapViewController {
        let uiViewController = MapViewController()
        uiViewController.mapView.delegate = context.coordinator
        return uiViewController
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        if let myLocation = self.myLocation {
            uiViewController.animateLocation(myLocation)
            myLocationMoveOneTime(true)
        }

        uiViewController.mapView.clear()
        
        let markers = pins.enumerated().map {
            let marker = GMSMarker(position: $0.element)
            marker.title = "\($0.offset)"
            return marker
        }
        markers.forEach { $0.map = uiViewController.mapView }
        
        let path = pins.reduce(GMSMutablePath()) {
            $0.add($1)
            return $0
        }
        let polyline = GMSPolyline(path: path)
        polyline.map = uiViewController.mapView
    }
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: MapViewControllerBridge
        
        init(_ mapViewControllerBridge: MapViewControllerBridge) {
            self.mapViewControllerBridge = mapViewControllerBridge
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            self.mapViewControllerBridge.didChangeCameraPosition(position)
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
}
