//
//  AnalyzeView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 18/05/24.
//

import SwiftUI
import CoreML
import Vision

struct AnalyzeView: View {
    @StateObject var camera = CameraModel()
    @StateObject private var icViewModel = ViewModel()

    var capturedImage: UIImage
    
    init(captureImage: UIImage){
        self.capturedImage = captureImage
    }

    var body: some View {
            VStack {
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                    icViewModel.updateClassifications(for: capturedImage)
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 700, height: 90)
                            .foregroundColor(.white.opacity(0.5))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        Text(icViewModel.classified)
                            .font(.system(size: 40))
                            .foregroundColor(.darkBrown)
                    }
                })
        }
    }
}
