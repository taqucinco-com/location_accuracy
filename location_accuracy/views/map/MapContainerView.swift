//
//  MapContainerView.swift
//  location_accuracy
//
//  Created by sudo takuya on 2024/03/03.
//

import SwiftUI

struct MapContainerView: View {
    var body: some View {
        GeometryReader { geometry in
            MapViewControllerBridge()
                .background(Color(
                    red: 254.0/255.0,
                    green: 1,
                    blue: 220.0/255.0)
                )
        }
    }
}

#Preview {
    MapContainerView()
}
