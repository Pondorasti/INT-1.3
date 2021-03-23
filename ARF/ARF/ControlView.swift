//
//  ControlView.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI

struct ControlView: View {
  @Binding var isControlsVisible: Bool
  @Binding var showBrowse: Bool
  
  var body: some View {
    VStack {
      ControlVisibilityToggleButton(isControlsVisible: $isControlsVisible)
      
      Spacer()
      
      if isControlsVisible {
        ControlButtonBar(showBrowse: $showBrowse)
          .transition(.move(edge: .bottom))
          .animation(.default)
      }
    }
  }
}

struct ControlVisibilityToggleButton: View {
  @Binding var isControlsVisible: Bool
  
  var body: some View {
    HStack {
      Spacer()
      
      ControlButton(systemIconName: isControlsVisible ? "rectangle" : "slider.horizontal.below.rectangle") {
        isControlsVisible.toggle()
      }
      .padding(16)
      .background(Color.black.opacity(0.25))
      .cornerRadius(24)
      .padding(16)
    }
  }
}

struct ControlButtonBar: View {
  @Binding var showBrowse: Bool
  
  var body: some View {
    HStack() {
      // Most Recent Buttton
      ControlButton(systemIconName: "clock.fill") {
        print("hello")
      }
      
      Spacer()
      
      // Browse Button
      ControlButton(systemIconName: "square.grid.2x2") {
        showBrowse.toggle()
      }.sheet(isPresented: $showBrowse) {
        BrowseView(showBrowse: $showBrowse)
      }
      
      Spacer()
      
      ControlButton(systemIconName: "slider.horizontal.3") {
        print("hello")
      }
    }
    .frame(maxWidth: 600)
    .padding(16)
    .background(Color.black.opacity(0.25))
    .cornerRadius(24)
  }
}

struct ControlButton: View {
  let systemIconName: String
  let action: () -> Void
  
  var body: some View {
    Button(action: action, label: {
      Image(systemName: systemIconName)
        .font(.system(size: 32))
        .foregroundColor(.white)
    })
    .frame(width: 48, height: 48)
  }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    ControlView(isControlsVisible: .constant(true), showBrowse: .constant(false))
  }
}
