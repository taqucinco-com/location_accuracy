//
//  File.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import Foundation

struct Env {
    static private let envPath = Bundle.main.path(forResource: "env", ofType: "plist")
    
    static func getGoogleMapKey() -> String? {
        guard let envPath = envPath else { return nil }
        guard let dict = NSDictionary(contentsOfFile: envPath) else { return nil }
        guard let ret = dict["GOOGLE_MAP_API_KEY"] as? String else { return nil }
        return ret
    }
}
