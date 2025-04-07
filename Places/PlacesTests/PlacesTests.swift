//
//  PlacesTests.swift
//  PlacesTests
//
//  Created by Woofer on 4/3/25.
//

import XCTest
@testable import Places // Replace with your module name

final class PlacesTests: XCTestCase {

    func testLocationAccessibilityLabelWithLocationName() {
        let location = Location(name: "Test Place", latitude: 40.7128, longitude: -74.0060)
        XCTAssertEqual(location.openWikipediaAccessibilityLabel, "Open Test Place in Wikipedia")
    }
    
    func testLocationAccessibilityLabelWithoutLocationName() {
        let location = Location(name: nil, latitude: 40.7128, longitude: -74.0060)
        XCTAssertEqual(location.openWikipediaAccessibilityLabel, "Open the Coordinates 40.7128, -74.006 in Wikipedia")
    }
    
    func testLoadLocationsFromRepository() async throws {
        let repository: LocationRepositoryProtocol = MockLocationRepository()
        let locations = try await repository.loadLocations()
        
        XCTAssertEqual(locations.count, 2)
        XCTAssertEqual(locations.first?.name, "Test Place 1")
        
        // Check that a location without a name returns the coordinates in the accessibility label.
        if let unnamedLocation = locations.last, unnamedLocation.name == nil {
            XCTAssertEqual(unnamedLocation.openWikipediaAccessibilityLabel, "Open the Coordinates \(unnamedLocation.latitude), \(unnamedLocation.longitude) in Wikipedia")
        }
    }
}

private class MockLocationRepository: LocationRepositoryProtocol {
    func loadLocations() async throws -> [Location] {
        let json = """
        {
            "locations": [
                { "name": "Test Place 1", "lat": 40.7128, "long": -74.0060 },
                { "name": null, "lat": 34.0522, "long": -118.2437 }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(LocationResponse.self, from: data)
        return response.locations
    }
}

