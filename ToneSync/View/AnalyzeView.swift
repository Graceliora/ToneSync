//
//  AnalyzeView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 18/05/24.
//

import SwiftUI

struct AnalyzeView: View {
    @StateObject var camera = CameraModel()
    @StateObject private var icViewModel = ViewModel()
    
    @State var back: Bool = false
    @State var next: Bool = false
    
    var capturedImage: UIImage
    init(captureImage: UIImage){
        self.capturedImage = captureImage
    }
    
    var body: some View {
        if back == false && next == false {
            VStack {
                Button(action: {
                    self.back = true
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.white)
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
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        self.next = true
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.white)
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
                }.padding(.trailing, 50)
                
                Spacer()
                
                Button(action: {
                    icViewModel.updateClassifications(for: capturedImage)
                }, label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 600, height: 90)
                            .foregroundColor(.darkBrown)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.darkBrown, lineWidth: 1)
                            )
                        Text(icViewModel.classified)
                            .font(.custom("Futura", size: 40))
                            .foregroundColor(.white)
                    }.padding(.bottom, 50)
                })
            }
        } else if back == true {
            ScanView()
        } else if next == true {
            RecommendationView(captureImage: capturedImage)
        } else {
            
        }
    }
}
