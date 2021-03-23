//
//  ContentView.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI
import RealityKit

struct ContentView: View {
  @EnvironmentObject var placementSettings: PlacementSettings
  @State private var isControlsVisible = true
  @State private var showBrowse = false
  
  var body: some View {
    ZStack(alignment: .bottom) {
      ARViewContainer()
        .edgesIgnoringSafeArea(.all)
      
      if placementSettings.selectedModel == nil {
        ControlView(isControlsVisible: $isControlsVisible, showBrowse: $showBrowse)
          .transition(.opacity)
      } else {
        PlacementView()
          .transition(.move(edge: .bottom))
      }
    }
  }
}

struct ARViewContainer: UIViewRepresentable {
  @EnvironmentObject var placementSettings: PlacementSettings
  
  func makeUIView(context: Context) -> CustomARView {
    let arView = CustomARView(frame: .zero)
    
    self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
      updateScene(for: arView)
    })
    
//    arView.debugOptions.insert(.showStatistics)
    
    return arView
  }
  
  func updateUIView(_ uiView: CustomARView, context: Context) {}
  
  private func updateScene(for arView: CustomARView) {
    arView.focusEntity?.isEnabled = placementSettings.selectedModel != nil
    
    if let confirmedModel = placementSettings.confirmedModel,
       let modelEntity = confirmedModel.modelEntity {
      
      place(modelEntity, in: arView)
      placementSettings.confirmedModel = nil
    }
  }
  
  private func place(_ modelEntity: ModelEntity, in arView: ARView) {
    let clonedEntity = modelEntity.clone(recursive: true)
    
    clonedEntity.generateCollisionShapes(recursive: true)
    arView.installGestures([.translation, .rotation], for: clonedEntity)
    
    let anchorEntity = AnchorEntity(plane: .any)
    anchorEntity.addChild(clonedEntity)
    
    arView.scene.addAnchor(anchorEntity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(PlacementSettings())
  }
}
