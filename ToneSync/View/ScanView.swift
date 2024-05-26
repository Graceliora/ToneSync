//
//  ScanView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 21/05/24.
//

import SwiftUI
import AVFoundation

struct ScanView: View {
    @StateObject var camera = CameraModel()
    @State var isActive: Bool = false
    @State var capturedImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                ZStack {
                    if camera.isTaken {
                        
                        if (isActive) {
                            AnalyzeView(captureImage: capturedImage ?? UIImage())
                            
                        } else {
                            ZStack {
                                RetakeButton(camera: camera)
                                
                                Button(action: {self.isActive = true}, label: {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: 90, height: 90)
                                            .foregroundColor(.white)
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
                            }.padding(.bottom, 160)
                        }
                        
                    } else {
                        ZStack {
                            Image(.layer)
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                            
                            VStack {
                                Spacer()
                                Text("Scan your face!")
                                    .font(.custom("Futura", size: 40))
                                    .foregroundColor(.white)
                                Spacer()
                                Image("faceFrame")
                                    .resizable()
                                    .frame(width: 455.4, height: 600)
                                    .padding(.leading, 5)
                                Spacer()
                                TakePhotoButton(camera: camera)
                                    .padding(.bottom, 100)
                                Spacer()
                            }
                        }
                    }
                }
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
                    .foregroundColor(.white)
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

struct TakePhotoButton: View {
    @ObservedObject var camera: CameraModel
    
    var body: some View {
        Button(action: {
            camera.takePhoto()
        }, label: {
            ZStack {
                Rectangle()
                    .frame(width: 180, height: 90)
                    .foregroundColor(.white)
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

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
