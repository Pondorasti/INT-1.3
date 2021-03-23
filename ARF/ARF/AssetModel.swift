//
//  AssetModel.swift
//  ARF
//
//  Created by Alexandru Turcanu on 14.03.2021.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
  case kitchen
  case garden
  case fun
  
  var label: String {
    switch self {
    case .kitchen:
      return "Kitchen"
    case .garden:
      return "Garden"
    case .fun:
      return "Fun"
    }
  }
}

class Model {
  var name: String
  var category: ModelCategory
  var thumbnail: String
  var modelEntity: ModelEntity?
  var scaleCompensation: Float
  
  private var cancellable: AnyCancellable?
  
  init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
    self.name = name
    self.thumbnail = name
    self.category = category
    self.scaleCompensation = scaleCompensation
  }
  
  func asyncLoadModelEntity() {
    let filename = self.name + ".usdz"
    
    cancellable = ModelEntity.loadModelAsync(named: filename).sink { (loadCompletion) in
      switch loadCompletion {
      case .failure(let error):
        print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
      case .finished:
        break
      }
    } receiveValue: { (modelEntity) in
      self.modelEntity = modelEntity
      self.modelEntity?.scale *= self.scaleCompensation
      
      print("modeEntity for \(self.name) has been loaded.")
    }
    
  }
}

struct Models {
  var all: [Model] = []
  
  init() {
    self.all += [
      Model(name: "chair_swan", category: .kitchen),
      Model(name: "cup_saucer_set", category: .kitchen),
      Model(name: "fender_stratocaster", category: .fun),
      Model(name: "flower_tulip", category: .garden),
      Model(name: "gramophone", category: .fun),
      Model(name: "pot_plant", category: .garden),
      Model(name: "teapot", category: .kitchen),
      Model(name: "toy_biplane", category: .fun),
      Model(name: "toy_car", category: .fun),
      Model(name: "toy_drummer", category: .fun),
      Model(name: "toy_robot_vintage", category: .fun),
      Model(name: "trowel", category: .garden),
      Model(name: "tv_retro", category: .kitchen),
      Model(name: "wateringcan", category: .garden),
      Model(name: "wheelbarrow", category: .garden),
    ]
  }
  
  func get(category: ModelCategory) -> [Model] {
    return all.filter({$0.category == category})
  }
}
