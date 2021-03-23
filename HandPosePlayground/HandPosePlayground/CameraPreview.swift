//
//  CameraPreview.swift
//  HandPosePlayground
//
//  Created by Alexandru Turcanu on 23.03.2021.
//

import UIKit
import AVFoundation

final class CameraPreview: UIView {
  override class var layerClass: AnyClass {
    AVCaptureVideoPreviewLayer.self
  }
  
  var previewLayer: AVCaptureVideoPreviewLayer {
    layer as! AVCaptureVideoPreviewLayer
  }
}
