//
//  CameraView.swift
//  HandPosePlayground
//
//  Created by Alexandru Turcanu on 23.03.2021.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
  var pointsProcessorHandler: (([CGPoint]) -> Void)?
  
  func makeUIViewController(context: Context) -> CameraViewController {
    let cvc = CameraViewController()
    cvc.pointsProcessorHandler = pointsProcessorHandler
    
    return cvc
  }
  
  func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
  }
}

