//
//  HomeScreen.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/10.
//

import SwiftUI
import CoreLocation
import AVFoundation
import TipKit

struct HomeScreen: View {
    
    private let locationService = LocationService.shared
    @State var auth: CLAuthorizationStatus = .notDetermined
    @State var myLocation: CLLocationCoordinate2D? = nil
    @State var pins: [CLLocationCoordinate2D] = []
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var recording = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            MapContainerView(
                myLocation: myLocation,
                pins: pins,
                authorized: authorized(),
                myLocationMoveOneTime: { _ in
                    myLocation = nil
                }
            )
            if auth == .authorizedAlways || auth == .authorizedWhenInUse {
                VStack {
                    Spacer()
                        .frame(height: 16.0)
                    HStack(alignment: .bottom) {
                        Spacer()
                        Button(action: {
                            if !recording {
                                startRecognizer()
                            } else {
                                stopRecognizer()
                            }
                            recording = !recording
                        }) {
                            Image(systemName: !recording ? "record.circle" : "stop.circle")
                                .foregroundColor(!recording ? .red : .gray)
                                .font(.largeTitle)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0 , bottom: 0, trailing: 16))
                    }
                    Spacer()
                    Button(action: {
                        requestLocation()
                    }) {
                        Text("現在地にピンを配置")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .help("recordと発話しても追加できます")
                    }
                    .popoverTip(AddTextTip(), arrowEdge: .top)
                }
            }
        }
        .onAppear {
            startLocation()
        }
        .onDisappear {
        }
    }
    
    private func startLocation() {
        locationService.requestAlwaysAuthorization()
        Task {
            for try await delegate in try await locationService.locationStream() {
                switch delegate {
                case .authorization(let status):
                    let tupple = (self.auth, status)
                    switch tupple {
                    case (.notDetermined, .authorizedAlways), (.notDetermined, .authorizedWhenInUse):
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
                        
                        await player.seek(to: .zero)
                        player.play()
                    }
                }
            }
        }
    }
    
    private func startRecognizer() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        speechRecognizer.onTranscriptToken = { token in
            if token == "record" {
                requestLocation()
            }
        }
    }
    
    private func stopRecognizer() {
        speechRecognizer.stopTranscribing()
    }
    
    private func requestLocation() {
        locationService.requestLocation()
    }
    
    private func authorized() -> Bool {
        switch auth {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}

#Preview {
    HomeScreen()
}
