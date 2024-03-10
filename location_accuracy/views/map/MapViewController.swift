//
//  MapViewController.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import UIKit
import SwiftUI
import GoogleMaps

class MapViewController: UIViewController {
    var mapView: GMSMapView!
    private let locationService = LocationService.shared
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = GMSMapView()
        mapView.frame = self.view.bounds
        self.view.addSubview(mapView)

        setup()
    }

    private func setup() {
        // カメラの初期位置を設定
        let camera = GMSCameraPosition.camera(
            withTarget: CLLocationCoordinate2D(latitude: 43.0, longitude: 141.0),
            zoom: 17.0,
            bearing: 0,
            viewingAngle: 40
        )
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }
    
    func animateLocation(_ coordinate: CLLocationCoordinate2D) {
        mapView.animate(toLocation: coordinate)
    }
}
