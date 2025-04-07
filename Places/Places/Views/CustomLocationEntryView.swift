//
//  CustomLocationEntryView.swift
//  Places
//
//  Created by Woofer on 4/6/25.
//

import SwiftUI

struct CustomLocationEntryView: View {
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Enter a custom location")
                .font(.headline)
            
            TextField("Latitude", text: self.$latitude)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation)
                .accessibilityLabel("Custom Latitude")
            
            TextField("Longitude", text: self.$longitude)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation)
                .accessibilityLabel("Custom Longitude")
            
            Button("Open Wikipedia") {
                if let lat = Double(self.latitude),
                   let lon = Double(self.longitude) {
                    let location = Location(name: "Custom", latitude: lat, longitude: lon)
                    Router().openWikipedia(for: location)
                }
            }
            .accessibilityLabel("Open Wikipedia for custom location")
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    CustomLocationEntryView()
}
