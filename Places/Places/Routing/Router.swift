//
//  Router.swift
//  Places
//
//  Created by Woofer on 4/6/25.
//

import SwiftUI

class Router {
    func openWikipedia(for location: Location) {
        let urlString = "wikipedia://places?lat=\(location.latitude)&lon=\(location.longitude)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
