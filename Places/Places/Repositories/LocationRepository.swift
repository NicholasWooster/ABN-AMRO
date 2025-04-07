//
//  LocationRepository.swift
//  Places
//
//  Created by Woofer on 4/3/25.
//

import Foundation

protocol LocationRepositoryProtocol {
    func loadLocations() async throws -> [Location]
}

struct LocationResponse: Codable {
    let locations: [Location]
}

class LocationRepository: LocationRepositoryProtocol {
    func loadLocations() async throws -> [Location] {
        guard let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json") else {
            throw LocationRepositoryError.failedToCreateLocationsUrl
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let response = try JSONDecoder().decode(LocationResponse.self, from: data)
                return response.locations
            } catch {
                throw LocationRepositoryError.failedToDecodeJSONData
            }
        } catch {
            throw LocationRepositoryError.failedToRetrieveLocations
        }
    }
}

enum LocationRepositoryError: Error, Identifiable {
    case failedToDecodeJSONData
    case failedToRetrieveLocations
    case failedToCreateLocationsUrl

    var id: String { self.localizedDescription }

    var localizedDescription: String {
        #if DEBUG
        switch self {
        case .failedToDecodeJSONData:
            return "Failed to decode JSON data."
        case .failedToCreateLocationsUrl:
            return "Failed to create URL for Locations endpoint."
        case .failedToRetrieveLocations:
            return "Failed to retrieve locations."
        }
        #else
            return "There was an error loading locations. Please try again later."
        #endif
    }
}
