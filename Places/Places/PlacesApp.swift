//
//  PlacesApp.swift
//  Places
//
//  Created by Woofer on 4/3/25.
//

import SwiftUI

@main
struct PlacesApp: App {
    private var locationRepository: LocationRepositoryProtocol = LocationRepository()
    
    var body: some Scene {
        WindowGroup {
            PlacesListView(locationRepository: self.locationRepository)
        }
    }
}
