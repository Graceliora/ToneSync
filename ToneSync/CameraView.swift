//
//  CameraView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 18/05/24.
//


import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var camera = CameraModel()
    
    @State var isActive: Bool = false
    
    @State var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            // Camera preview
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                ZStack {
                    // Show retake button if photo is taken
                    if camera.isTaken {
                        if (isActive) {
                            AnalyzeView(captureImage: capturedImage ?? UIImage())
                        } else {
                            // Retake photo button
                            RetakeButton(camera: camera)
                            
                            // Analyze photo button
                            Button(action: {self.isActive = true}, label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 90, height: 90)
                                        .foregroundColor(.white.opacity(0.5))
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white, lineWidth: 1)
                                        )
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.darkBrown)
                                }
                            }).padding(.leading, 520)
                        }
                        
                    } else {
                            // Pick photo button
                            ImageButton()
                            
                            // Take photo button
                            TakePhotoButton(camera: camera)
                    }
                }.padding(.bottom, 120)
            }
        }
        .onAppear {
            camera.checkPermission()
        }
        .onReceive(camera.$capturedPhoto) { output in
            if let image = output{
                self.capturedImage = image
            }
        }
    }
}

struct RetakeButton: View {
    @ObservedObject var camera: CameraModel
    
    var body: some View {
        Button(action: {
            camera.retakePhoto()
        }, label: {
            ZStack {
                Rectangle()
                    .frame(width: 180, height: 90)
                    .foregroundColor(.white.opacity(0.5))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.darkBrown)
            }
        })
    }
}

struct ImageButton: View {
    var body: some View {
        Button(action: {}, label: {
            ZStack {
                Rectangle()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.white.opacity(0.5))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                Image(systemName: "photo.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.darkBrown)
            }
        }).padding(.trailing, 520)
    }
}

struct TakePhotoButton: View {
    @ObservedObject var camera: CameraModel
    
    var body: some View {
        Button(action: {
            camera.takePhoto()
        }, label: {
            ZStack {
                Rectangle()
                    .frame(width: 180, height: 90)
                    .foregroundColor(.white.opacity(0.5))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                Image(systemName: "camera.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.darkBrown)
            }
        })
    }
}

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

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your own properties
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // Starting session
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    CameraView()
}
