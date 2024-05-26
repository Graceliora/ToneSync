//
//  CameraModel.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 21/05/24.
//

import Foundation
import AVFoundation
import SwiftUI

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    
    // Read pic data
    @Published var output = AVCapturePhotoOutput()
    
    // Preview
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    // Captured Picture
    @Published var capturedPhoto: UIImage? = nil
    
    var viewModel: ViewModel?
    
    func checkPermission() {
        // First checking camera has got permission...
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            // Setting up session
            setUp()
            
        case .notDetermined:
            // Retusting for permission
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    DispatchQueue.main.async {
                        self.setUp()
                    }
                }
            }
            
        case .denied, .restricted:
            alert = true
            
        @unknown default:
            break
        }
    }
    
    func setUp() {
        // Setting up camera...
        do {
            // Setting configs
            session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let input = try AVCaptureDeviceInput(device: device!)
            
            
            
            // Checking and adding to session...
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            // Same for output
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Error converting AVCapturePhoto to UIImage: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        self.capturedPhoto = image
//        viewModel?.selectedImage = capturedPhoto÷0
    }
    
    func retakePhoto() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
}
