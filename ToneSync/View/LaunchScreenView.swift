//
//  LaunchScreenView.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 17/05/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @State var isActive: Bool = false
    
    @State private var rad = 0.0
    @State private var op = 0.0
    @State private var txtOp = 0.0
    
    var body: some View {
        
        ZStack {
            if self.isActive {
                ScanView()
            } else {
                ZStack {
                    Image("launchBg")
                        .ignoresSafeArea()
                        .blur(radius: rad)
                    
                    Rectangle()
                        .foregroundColor(.darkBrown.opacity(op))
                        .ignoresSafeArea()
                    
                    Text("Tone Sync")
                        .font(.custom("Futura", size: 64))
                        .opacity(txtOp)
                        .foregroundColor(.white)
                    
                }.onAppear {
                    withAnimation(.easeIn(duration: 3)) {
                        self.rad = 6
                        self.op = 0.5
                    }
                    withAnimation(.easeIn(duration: 3).delay(2.5)) {
                        self.txtOp = 1
                    }
                }
                
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
