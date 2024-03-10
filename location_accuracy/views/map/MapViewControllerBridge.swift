//
//  MapViewControllerBridge.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import UIKit
import SwiftUI
import GoogleMaps

struct MapViewControllerBridge: UIViewControllerRepresentable {
    
    @Binding var myLocation: CLLocationCoordinate2D?
    @Binding var pins: [CLLocationCoordinate2D]
    
    typealias UIViewControllerType = MapViewController

    func makeUIViewController(context: Context) -> MapViewController {
        MapViewController()
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        if let myLocation = self.myLocation {
            uiViewController.animateLocation(myLocation)
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
}
