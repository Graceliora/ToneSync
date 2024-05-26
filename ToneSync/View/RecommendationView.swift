//
//  RecommendationView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 21/05/24.
//

import SwiftUI

struct LiveFeedViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LiveFeedViewController {
        return LiveFeedViewController()
    }

    func updateUIViewController(_ uiViewController: LiveFeedViewController, context: Context) {
        // Update code if needed
    }
}

struct RecommendationView: View {
    
    @ObservedObject private var icViewModel = ViewModel()
    
    var capturedImage: UIImage
    
    init(captureImage: UIImage){
        self.capturedImage = captureImage
    }
    
    var body: some View {
        ZStack {
            LiveFeedViewControllerWrapper()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .frame(width: 640, height: 327)
                        .foregroundColor(.darkBrown.opacity(0.5))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.darkBrown, lineWidth: 1)
                        )
                    HStack {
                        Image(.lipstick)
                            .resizable()
                            .frame(width: 113, height: 254)
                        Spacer()
                            .frame(width: 40)
                        VStack(alignment: .leading){
                            Spacer()
                            Spacer()
                            Text("Lipstick")
                                .font(.custom("Futura", size: 40))
                                .foregroundColor(.white)
                            Spacer()
                            Text("Discover the perfect lipstick shade for your unique skin tone with our expert recommendations.")
                                .font(.custom("Futura", size: 24))
                                .foregroundColor(.white)
                            Spacer()
                            HStack {
                                Circle()
                                    .foregroundColor(icViewModel.color1)
                                Circle()
                                    .foregroundColor(icViewModel.color2)
                                Circle()
                                    .foregroundColor(icViewModel.color3)
                                Circle()
                                    .foregroundColor(icViewModel.color4)
                                Circle()
                                    .foregroundColor(icViewModel.color5)
                            }
                            Spacer()
                            Spacer()
                        }
                    }.frame(width: 536, height: 327)
                }
            }.padding(.bottom, 100)
        }.onAppear {
            icViewModel.updateClassifications(for: capturedImage)
        }
    }

}
