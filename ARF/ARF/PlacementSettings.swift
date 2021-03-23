//
//  PlacementSettings.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI
import Combine
import RealityKit

class PlacementSettings: ObservableObject {
  // When the user selects the Model from the BrowseView
  @Published var selectedModel: Model? {
    willSet(newValue) {
      print("Settings selectedModel to \(String(describing: newValue?.name))")
    }
  }
  
  // When the User taps and confirms the placement of the model
  @Published var confirmedModel: Model? {
    willSet(newValue) {
      guard let model = newValue else {
        print("Clearing confirmedModel")
        return
      }
      
      print("Setting confirmedModel to \(model.name)")
    }
  }
  
  // SceneEvents.Update subscriber
  var sceneObserver: Cancellable?
}
