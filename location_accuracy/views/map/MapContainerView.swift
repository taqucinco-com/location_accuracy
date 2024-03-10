//
//  MapContainerView.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import SwiftUI
import CoreLocation
import GoogleMaps

struct MapContainerView: View {
    
    let myLocation: CLLocationCoordinate2D?
    let pins: [CLLocationCoordinate2D]
    var didChangeCameraPosition: (GMSCameraPosition) -> () = { print($0) }
    
    var myLocationMoveOneTime: (Bool) -> ()
    
    var body: some View {
        // MapViewControllerBridgeに対する単方向bindingに変換する
        let _myLocation = Binding<CLLocationCoordinate2D?>(
            get: { myLocation },
            set: { _ in }
        )
        let _pins = Binding<[CLLocationCoordinate2D]>(
            get: { pins },
            set: { _ in }
        )
        ZStack {
            GeometryReader { geometry in
                MapViewControllerBridge(
                    myLocation: _myLocation,
                    pins: _pins,
                    didChangeCameraPosition: didChangeCameraPosition,
                    myLocationMoveOneTime: myLocationMoveOneTime
                )
                    .background(Color(
                        red: 254.0/255.0,
                        green: 1,
                        blue: 220.0/255.0)
                    )
            }
        }
    }
}

#Preview {
    return MapContainerView(
        myLocation: nil,
        pins: [],
        didChangeCameraPosition: { _ in },
        myLocationMoveOneTime: { _ in }
    )
}
