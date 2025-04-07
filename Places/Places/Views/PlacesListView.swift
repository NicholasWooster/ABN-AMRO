//
//  PlacesListView.swift
//  Places
//
//  Created by Woofer on 4/3/25.
//

import SwiftUI

struct PlacesListView: View {
    @State private var locations: [Location] = []
    @State private var locationRepositoryError: LocationRepositoryError?
    
    private var locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.locations) { location in
                    Button(location.name ?? "\(location.latitude), \(location.longitude)") {
                        Router().openWikipedia(for: location)
                    }
                    .accessibilityLabel(location.openWikipediaAccessibilityLabel)
                }
                .accessibilityIdentifier("LocationsList")

                NavigationLink(destination: CustomLocationEntryView()) {
                    Text("Enter a Custom Location")
                        .font(.headline)
                        .padding()
                }
                .accessibilityLabel("Navigate to custom location entry")
            }
            .navigationTitle("Places")
            .alert(item: self.$locationRepositoryError) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .task {
            do {
                self.locations = try await self.locationRepository.loadLocations()
            } catch let error as LocationRepositoryError {
                self.locationRepositoryError = error
            } catch {
                self.locationRepositoryError = .failedToRetrieveLocations
            }
            
        }
    }
}

#Preview {
    PlacesListView(locationRepository: LocationRepository())
}
