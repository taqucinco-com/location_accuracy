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
    typealias UIViewControllerType = MapViewController

    func makeUIViewController(context: Context) -> MapViewController {
        MapViewController()
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
}
