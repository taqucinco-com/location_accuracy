//
//  LocationService.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/04.
//

import Foundation
import CoreLocation

enum LocationServiceStream {
    case authorization(CLAuthorizationStatus)
    case locations([CLLocation])
}

class LocationService: NSObject, ObservableObject {
    
    static let shared = LocationService()
    
    lazy var locationManager: CLLocationManager = CLLocationManager()
    private var authDelegate: LocationServiceDelegate?

    override init() {
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 1.0
        self.locationManager.activityType = CLActivityType.fitness
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    /// 位置情報への権限をユーザーに要求する
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // 位置情報権限のストリーム
    func deleteStream() async throws -> AsyncStream<LocationServiceStream> {
        let stream = AsyncStream<LocationServiceStream> { continuation in
            continuation.yield(.authorization(locationManager.authorizationStatus))
            self.authDelegate = LocationServiceDelegate(
                didUpdateLocations: {
                    continuation.yield(.locations($0))
                },
                didChangeAuthorization: {
                    continuation.yield(.authorization($0))
                }
            )
            self.locationManager.delegate = self.authDelegate
        }
        return stream
    }
    
    /// 位置情報の監視を開始する
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    /// 位置情報の監視を停止する
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getLocation() -> CLLocation? {
        locationManager.location
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

final class LocationServiceDelegate: NSObject, CLLocationManagerDelegate, Sendable {
    let didUpdateLocations: @Sendable ([CLLocation]) -> Void
    let didChangeAuthorization: @Sendable (CLAuthorizationStatus) -> Void
    let didFinishDeferredUpdatesWithError: @Sendable (Error?) -> Void
    
    init(
        didUpdateLocations: @Sendable @escaping ([CLLocation]) -> Void = { _ in },
        didChangeAuthorization: @Sendable @escaping (CLAuthorizationStatus) -> Void = { _ in },
        didFinishDeferredUpdatesWithError: @Sendable @escaping (Error?) -> Void = { _ in }
    ) {
        self.didUpdateLocations = didUpdateLocations
        self.didChangeAuthorization = didChangeAuthorization
        self.didFinishDeferredUpdatesWithError = didFinishDeferredUpdatesWithError
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations(locations)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        didChangeAuthorization(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        didFinishDeferredUpdatesWithError(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
