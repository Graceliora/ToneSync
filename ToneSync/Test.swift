//
//  Test.swift
//  ToneSync
//
//  Created by Gracella Noveliora on 21/05/24.
//

import SwiftUI

struct Test: View {
    var body: some View {
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
                        Text("Lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet.")
                            .font(.custom("Futura", size: 24))
                            .foregroundColor(.white)
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }.frame(width: 536, height: 327)
            }
        }.padding(.bottom, 100)
    }
}

#Preview {
    Test()
}
