//
//  BrowseView.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI

struct BrowseView: View {
  @Binding var showBrowse: Bool
  
  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        ModelsByCategoryGrid(showBrowse: $showBrowse)
      }
      .navigationBarTitle(Text("Browse"), displayMode: .large)
      .navigationBarItems(trailing:
        Button("Done") {
          showBrowse = false
        }
      )
    }
  }
}

struct ModelsByCategoryGrid: View {
  @Binding var showBrowse: Bool
  
  let models = Models()
  
  var body: some View {
    VStack {
      ForEach(ModelCategory.allCases, id: \.self) { category in
        if (category.label != "Kitchen") {
          Divider()
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
        }
        
        HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: models.get(category: category))
      }
    }
  }
}

struct HorizontalGrid: View {
  @EnvironmentObject var placementSettings: PlacementSettings
  @Binding var showBrowse: Bool
  
  var title: String
  var items: [Model]
  
  private let gridItemLayout = [GridItem(.fixed(150))]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.title2).bold()
        .padding(.leading, 24)
        .padding(.top, 8)
      
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHGrid(rows: gridItemLayout, spacing: 32) {
          ForEach(0..<items.count) { index in
            ItemButton(model: items[index]) {
              items[index].asyncLoadModelEntity()
              withAnimation { placementSettings.selectedModel = items[index] }
              showBrowse = false
            }
          }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
      }
    }
  }
}

struct ItemButton: View {
  let model: Model
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Color(UIColor.secondarySystemGroupedBackground)
        .frame(width: 160, height: 160)
        .cornerRadius(8)
        .overlay(Text(model.name))
    }
  }
}

struct BrowseView_Previews: PreviewProvider {
  static var previews: some View {
    BrowseView(showBrowse: .constant(true))
  }
}
