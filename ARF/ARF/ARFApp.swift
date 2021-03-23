//
//  ARFApp.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI

@main
struct ARFApp: App {
  @StateObject var placementSettings = PlacementSettings()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(placementSettings)
    }
  }
}
