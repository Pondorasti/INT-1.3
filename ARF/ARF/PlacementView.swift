//
//  PlacementView.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI

struct PlacementView: View {
  @EnvironmentObject var placementSettings: PlacementSettings
  
  var body: some View {
    HStack {
      ControlButton(systemIconName: "xmark.circle.fill") {
        print("cancel")
        withAnimation {
          placementSettings.selectedModel = nil
        }
      }
      
      Spacer()
      
      ControlButton(systemIconName: "checkmark.circle.fill") {
        print("evet")
        withAnimation {
          placementSettings.confirmedModel = placementSettings.selectedModel
          placementSettings.selectedModel = nil
        }
      }
    }
    .frame(maxWidth: 300)
    .padding(16)
    .background(Color.black.opacity(0.25))
    .cornerRadius(24)
  }
}

struct PlacementButton: View {
  let systemIconName: String
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Image(systemName: systemIconName)
        .font(.system(size: 48, weight: .light, design: .default))
        .foregroundColor(.white)
    }
    .frame(width: 80, height: 80)
  }
}
