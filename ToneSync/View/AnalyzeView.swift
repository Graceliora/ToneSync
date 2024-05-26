//
//  AnalyzeView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 18/05/24.
//

import SwiftUI
//import CoreML
//import Vision

struct AnalyzeView: View {
    @StateObject var camera = CameraModel()
    @StateObject private var icViewModel = ViewModel()
    
    @State var back: Bool = false
    var capturedImage: UIImage
    
    init(captureImage: UIImage){
        self.capturedImage = captureImage
    }
    
    var body: some View {
        if back == false {
            VStack {
                Button(action: {
                    self.back = true
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.white.opacity(0.5))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        Image(systemName: "chevron.left")
                            .font(.system(size: 40))
                            .foregroundColor(.darkBrown)
                    }.padding(.trailing, 550).padding(.top, 80)
                })
                HStack {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(x: -1, y: 1)
                        .frame(height: 700)
                    
                    Button(action: {
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.white.opacity(0.5))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.darkBrown)
                        }
                    })
                }.padding(.leading, 100)
                Button(action: {
                    icViewModel.updateClassifications(for: capturedImage)
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 600, height: 90)
                            .foregroundColor(.darkBrown.opacity(0.5))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.darkBrown, lineWidth: 1)
                            )
                        Text(icViewModel.classified)
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }.padding(.top, 50)
                })
                Spacer()
            }
        } else {
            ScanView()
        }
    }
}
