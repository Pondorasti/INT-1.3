//
//  CameraViewController.swift
//  HandPosePlayground
//
//  Created by Alexandru Turcanu on 23.03.2021.
//

import UIKit
import AVFoundation
import Vision

enum AppError: Error {
  case captureSessionSetup(reason: String)
}

final class CameraViewController: UIViewController {
  
  // MARK: - Properties
  
  private var cameraView: CameraPreview { view as! CameraPreview }
  private var cameraFeedSession: AVCaptureSession?
  private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
  
  private let handPoseRequest: VNDetectHumanHandPoseRequest = {
    let request = VNDetectHumanHandPoseRequest()
    
    request.maximumHandCount = 2
    return request
  }()
  
  
  // MARK: - Lifecycle
  override func loadView() {
    view = CameraPreview()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    do {
      if cameraFeedSession == nil {
        try setupAVSession()
        
        cameraView.previewLayer.session = cameraFeedSession
        cameraView.previewLayer.videoGravity = .resizeAspectFill
      }
      
      cameraFeedSession?.startRunning()
    } catch {
      assertionFailure(error.localizedDescription)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    cameraFeedSession?.stopRunning()
    super.viewWillDisappear(animated)
  }
  
  
  // MARK: - Functions
  func setupAVSession() throws {
    // Check if device is available
    guard let videoDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
    else {
      throw AppError.captureSessionSetup(reason: "Could not find a front facing camera")
    }
    
    // Create device input
    guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
      throw AppError.captureSessionSetup(reason: "Could not creare video device input.")
    }
    
    // Create capture session
    let session = AVCaptureSession()
    session.beginConfiguration()
    session.sessionPreset = AVCaptureSession.Preset.high
    
    // Add deviceInput to session
    guard session.canAddInput(deviceInput) else {
      throw AppError.captureSessionSetup(reason: "Could not add video device input to the session.")
    }
    session.addInput(deviceInput)
    
    // Create data outut
    let dataOutput = AVCaptureVideoDataOutput()
    guard session.canAddOutput(dataOutput) else {
      throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
    }
    session.addOutput(dataOutput)
    dataOutput.alwaysDiscardsLateVideoFrames = true
    dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
    
    
    // Update properties
    session.commitConfiguration()
    cameraFeedSession = session
  }
  
  var pointsProcessorHandler: (([CGPoint]) -> Void)?
  func processPoints(_ fingerTips: [CGPoint]) {
    let convertedPoints = fingerTips.map {
      cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
    }
    
    pointsProcessorHandler?(convertedPoints)
  }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
    var fingerTips: [CGPoint] = []
    
    defer {
      DispatchQueue.main.sync {
        self.processPoints(fingerTips)
      }
    }
    
    do {
      // Perform Vision request
      try handler.perform(([handPoseRequest]))
      
      // Make sure we have detected something
      guard let results = handPoseRequest.results?.prefix(2), !results.isEmpty else {
        return
      }
      
      // Get finger tips
      var recognizedPoints: [VNRecognizedPoint] = []
      
      try results.forEach { observation in
        let fingers = try observation.recognizedPoints(.all)
        
        if let thumbTipPoint = fingers[.thumbTip] {
          recognizedPoints.append(thumbTipPoint)
        }
        if let indexTipPoint = fingers[.indexTip] {
          recognizedPoints.append(indexTipPoint)
        }
        if let middleTipPoint = fingers[.middleTip] {
          recognizedPoints.append(middleTipPoint)
        }
        if let ringTipPoint = fingers[.ringTip] {
          recognizedPoints.append(ringTipPoint)
        }
        if let littleTipPoint = fingers[.littleTip] {
          recognizedPoints.append(littleTipPoint)
        }
      }
      
      // Normalize data
      fingerTips = recognizedPoints.filter {
        $0.confidence > 0.75
      }.map {
        CGPoint(x: $0.location.x, y: 1 - $0.location.y)
      }
    } catch {
      cameraFeedSession?.stopRunning()
    }
  }
}

