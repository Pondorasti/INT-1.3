//
//  ContentView.swift
//  HandPosePlayground
//
//  Created by Alexandru Turcanu on 23.03.2021.
//

import SwiftUI

struct ContentView: View {
  @State private var overlayPoints: [CGPoint] = []
  
  var body: some View {
    ZStack {
      CameraView {
        overlayPoints = $0
      }
      .overlay(
        ZStack {
          ForEach(0..<overlayPoints.count, id: \.self) { index in
            Blur(style: .systemThickMaterialLight)
              .frame(width: 24, height: 24)
              .clipShape(Circle())
              .position(overlayPoints[index])
          }
//          FingersOverlay(with: overlayPoints)
//            .foregroundColor(.orange)
        }
      )
      .edgesIgnoringSafeArea(.all)
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
