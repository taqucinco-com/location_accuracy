//
//  location_accuracyApp.swift
//  location_accuracy
//
//  Created by takuyasudo on 2024/03/03.
//

import SwiftUI

@main
struct location_accuracyApp: App {
    @UIApplicationDelegateAdaptor (AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

import UIKit
import GoogleMaps
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        guard let apiKey = Env.getGoogleMapKey() else { return true }
        GMSServices.provideAPIKey(apiKey)
        
        return true
    }
}
