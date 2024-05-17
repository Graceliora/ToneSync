//
//  AnalyzeView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 18/05/24.
//

import SwiftUI

struct AnalyzeView: View {
    
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            // Show captured image
            if let photo = camera.capturedPhoto {
                Image(uiImage: photo)
                    .ignoresSafeArea(.all, edges: .all)
            }
        }
    }
}

#Preview {
    AnalyzeView()
}
