//
//  ContentView.swift
//  location_accuracy
//
//  Created by takuyasudo on 2024/03/03.
//

import SwiftUI

struct ContentView: View {
    
    @State private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.routes) {
            HomeScreen()
//                .navigationDestination(for: String.self) {
//                    switch $0 {
//                    default:
//                        EmptyView()
//                    }
//                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
