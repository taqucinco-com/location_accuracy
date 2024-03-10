//
//  MapContainerView.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import SwiftUI
import CoreLocation

struct MapContainerView: View {
    private let locationService = LocationService.shared
    @State var auth: CLAuthorizationStatus = .notDetermined
    @State var myLocation: CLLocationCoordinate2D? = nil
    @State var pins: [CLLocationCoordinate2D] = []
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                MapViewControllerBridge(
                    myLocation: $myLocation,
                    pins: $pins
                )
                    .background(Color(
                        red: 254.0/255.0,
                        green: 1,
                        blue: 220.0/255.0)
                    )
            }
            if auth == .authorizedAlways || auth == .authorizedWhenInUse {
                VStack {
                    Spacer()
                    Button(action: {
                        // Action to perform when the button is tapped
                        locationService.requestLocation()
                    }) {
                        Text("add")
                            .padding() // Add padding to the text inside the button
                            .foregroundColor(.white) // Set text color
                            .background(Color.blue) // Set background color
                            .cornerRadius(10) // Set corner radius to create a rounded rectangle
                    }
                }
            }
        }
        .onAppear {
            locationService.requestAlwaysAuthorization()
            Task {
                for try await delegate in try await locationService.deleteStream() {
                    switch delegate {
                    case .authorization(let status):
                        let tupple = (self.auth, status)
                        switch tupple {
                        case (.notDetermined, .authorizedAlways), (.authorizedWhenInUse, .restricted):
                            if let coordinate = locationService.getLocation()?.coordinate {
                                myLocation = coordinate
                            }
                        default:
                            break
                        }
                        self.auth = status
                    case .locations(let locations):
                        if let coordinate = locations.first?.coordinate {
                            pins = pins + [coordinate]
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MapContainerView()
}
