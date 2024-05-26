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

    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var capturedPhoto: UIImage? = nil
    
    var viewModel: ViewModel?
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            setUp()
            
        case .notDetermined:
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
        do {
            session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
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
