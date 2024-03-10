//
//  HomeScreen.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/10.
//

import SwiftUI
import CoreLocation

struct HomeScreen: View {
    
    private let locationService = LocationService.shared
    @State var auth: CLAuthorizationStatus = .notDetermined
    @State var myLocation: CLLocationCoordinate2D? = nil
    @State var pins: [CLLocationCoordinate2D] = []
    
    var body: some View {
        let mapView = MapContainerView(
            myLocation: myLocation,
            pins: pins,
            myLocationMoveOneTime: { _ in
                myLocation = nil
            }
        )
        ZStack {
            mapView
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
    HomeScreen()
}
