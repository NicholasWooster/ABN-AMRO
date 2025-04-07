//
//  Location.swift
//  Places
//
//  Created by Nicholas Wooster on 4/3/25.
//

import Foundation

struct Location: Codable, Identifiable {
    let id: UUID = UUID()
    let name: String?
    let latitude: Double
    let longitude: Double
    
    var openWikipediaAccessibilityLabel: String {
        if let name = self.name, !name.isEmpty {
            return "Open \(name) in Wikipedia"
        } else {
            return "Open the Coordinates \(self.latitude), \(self.longitude) in Wikipedia"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
